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

resource "aws_iam_role" "eks_nodes_role" {
  name = var.nodeGroupRoleName

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
          Service = "ec2.amazonaws.com"
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

resource "aws_iam_role_policy_attachment" "nodeGroup_attach-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "nodeGroup_attach-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "nodeGroup_attach-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes_role.name
}

# Get VPC and Subnets
data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_subnet" "subnet_ids" {
  count = "${length(data.aws_subnet_ids.subnets.ids)}"
  id    = "${tolist(data.aws_subnet_ids.subnets.ids)[count.index]}"
}

# Create EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = var.clusterName
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = "${data.aws_subnet.subnet_ids.*.id}"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_attach
  ]
}

# Create Worker Node Group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.nodeGroupName
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = "${data.aws_subnet.subnet_ids.*.id}"

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.nodeGroup_attach-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodeGroup_attach-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodeGroup_attach-AmazonEC2ContainerRegistryReadOnly
  ]
}

# Output informations about cluster
output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}