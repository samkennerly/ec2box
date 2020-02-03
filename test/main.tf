provider "aws" {
  profile = var.profile
  region  = var.region
}

# Rent some boxes
module "dorothy" {
  name    = "dorothy"
  install = "${path.module}/dorothy/install"
  launch  = "${path.module}/dorothy/launch"
  source  = "./.."
}
module "leeroy" {
  name    = "leeroy"
  ec2type = "t3.nano"
  source  = "./.."
}
module "monty" {
  name    = "monty"
  diskgb  = 10
  install = "${path.module}/monty/install"
  launch  = "${path.module}/monty/launch"
  source  = "./.."
}
