terraform {
  required_providers {
      aws = {
          source  = "hashicorp/aws"
          version = "3.7"
      }
  }
}

provider "aws" {
  region = "eu-west-2"
}

module "webserver" {
  source     = "./modules/terraform-aws-webserver"

  servername = "webserver1"
  size       = "t3.micro"
}

output "public_ip" {
  value = module.webserver.public_ip
}