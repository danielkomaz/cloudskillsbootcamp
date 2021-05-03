terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Configure Roles for Cluster and NodeGroup
resource "aws_iam_role" "eks_role" {
  name = var.roleName

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# Get IAM Policies
data "aws_iam_policy" "eks_policy" {
  name = "AmazonEKSClusterPolicy"
}

# Attach IAM policies to roles
resource "aws_iam_role_policy_attachment" "eks_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = data.aws_iam_policy.eks_policy.arn
}

# Get VPC and Subnets
data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_subnet" "subnet_ids" {
  count = length(data.aws_subnet_ids.subnets.ids)
  id    = tolist(data.aws_subnet_ids.subnets.ids)[count.index]
}

# Create EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.clusterName
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = data.aws_subnet.subnet_ids.*.id
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_attach,
    aws_subnet.private
  ]
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = data.aws_vpc.vpc.id
  cidr_block = "172.16.0.0/24"
}

resource "aws_subnet" "private" {
  vpc_id                   = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block               = "172.16.0.0/25"
  
}

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.vpc.id

  route = []
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_iam_role" "eks_fargate_role" {
  name                  = "${var.clusterName}-fargate_cluster_role"
  description           = "Allow fargate cluster to allocate resources for running pods"
  force_detach_policies = true
  assume_role_policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "eks.amazonaws.com",
          "eks-fargate-pods.amazonaws.com"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_fargate_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_fargate_role.name
}

resource "aws_eks_fargate_profile" "eks_fargate" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "${var.clusterName}-fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn
  subnet_ids             = [aws_subnet.private.id]

  selector {
    namespace = "cludskills-eks"
  }

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "fargate_role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
resource "aws_iam_role" "ecs_task_role" {
  name = "fargate_task"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role_policy_attachment" "task_s3" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_ecs_task_definition" "definition" {
  family                   = "task_definition_name"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]

  container_definitions = <<DEFINITION
[
  {
    "image": "nginx:latest",
    "name": "project-container"
  }
]
DEFINITION
}