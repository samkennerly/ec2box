
provider "aws" {
  profile = var.profile
  region  = var.region
}

module "test" {
  source = "../src"
  name   = "test"
}
