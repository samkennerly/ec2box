provider "aws" {
  profile = var.profile
  region  = var.region
}

# Rent some boxes
module "leeroy" {
  ec2type = "t3.nano"
  name    = "leeroy"
  source  = "./.."
}
module "dorothy" {
  diskgb  = 10
  install = "${path.module}/dorothy/install"
  launch  = "${path.module}/dorothy/launch"
  name    = "dorothy"
  source  = "./.."
}
