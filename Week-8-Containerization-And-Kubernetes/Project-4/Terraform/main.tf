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
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    stack = "cloudskillseks"
  }
}

data "aws_iam_policy" "eks_policy" {
  name = "AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = data.aws_iam_policy.eks_policy.arn
}

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

output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}