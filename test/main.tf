
provider "aws" {
  profile = var.profile
  region  = var.region
}

module "test" {
  name   = "test"
  source = "../src"
}

module "slippers" {
  name = "slippers"
  launch = "${path.module}/slippers"
  source = "../src"
}
