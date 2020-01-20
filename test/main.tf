provider "aws" {
  profile = var.profile
  region  = var.region
}

module "dorothy" {
  name   = "dorothy"
  launch = "${path.module}/slippers"
  source = "../src"
}

module "leeroy" {
  name    = "leeroy"
  ec2type = "t3.nano"
  source  = "../src"
}
