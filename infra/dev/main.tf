terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.68"
    }
  }

  required_version = ">= 0.14.10"
}

provider "aws" {
  profile = "default" 
  region = "us-east-1"
}

resource "aws_instance" "Terraform-Mnist-ec2" {
  ami = "ami-0ed9277fb7eb570c9"
  instance_type = "t2.micro"

  tags = {
    Name = "MnistDevBranchInstance"
    Terraform = "True"
  }
}
