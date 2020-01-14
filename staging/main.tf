terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
  version = "~> 2.44" # AWS plugin version to install
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
