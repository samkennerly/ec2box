# Terraform setup
terraform {
  required_providers {
    aws   = "~> 2.44"
  }
  required_version = "~> 0.12"
}

# Local variables
locals {
  folder     = "${path.module}/../etc"
  public_key = file("${local.folder}/id_rsa.pub")
  user_data  = templatefile("${local.folder}/user_data", local.user_vars)
  user_vars  = {
    awslogs = file("${local.folder}/awslogs.conf")
    ec2user = "ec2-user"
  }
}

# AWS credentials
provider "aws" {
  profile = var.profile
  region  = var.region
}
resource "aws_key_pair" "ec2box" {
  key_name   = var.name
  public_key = local.public_key
}

# AWS security group for EC2 instances
resource "aws_security_group" "ec2box" {
  description = "Allow SSH login and all outbound connections"
  name        = var.name

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
}

# EC2 instance
resource "aws_instance" "ec2box" {
  ami             = lookup(var.amis, var.region)
  instance_type   = var.type
  key_name        = aws_key_pair.ec2box.key_name
  security_groups = [aws_security_group.ec2box.name]
  tags            = { Name = var.name }
  user_data       = local.user_data
  volume_tags     = { Name = var.name }

  root_block_device {
    volume_size = var.gb
  }
}
