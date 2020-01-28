provider "aws" {
  profile = var.profile
  region  = var.region
}
module "leeroy" {
  name    = "leeroy"
  ec2type = "t3.nano"
  source  = "./.."
}
module "dorothy" {
  name    = "dorothy"
  install = "${path.module}/dorothy/install"
  launch  = "${path.module}/dorothy/launch"
  source  = "./.."
}
