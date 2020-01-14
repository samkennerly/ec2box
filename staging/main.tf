terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
  required_providers {
    aws = "~> 2.44"
  }
  required_version = "~> 0.12"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_instance" "ec2box" {
  ami           = lookup(var.amis, var.region)
  instance_type = var.type
  tags          = { Name = "ec2box" }
  volume_tags   = { Name = "ec2box" }

  root_block_device {
    volume_size = var.gb
  }
}
