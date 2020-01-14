variable "amis" {
  default = {
    "eu-west-1" = "ami-0713f98de93617bb4"
    "us-east-1" = "ami-062f7200baf2fa504"
    "us-west-1" = "ami-03caa3f860895f82e"
  }
  description = "Amazon Machine Image for each region"
}
variable "gb" {
  default     = "8"
  description = "Root volume size (GB)"
}
variable "profile" {
  default     = "default"
  description = "AWS profile from ~/.aws/credentials"
}
variable "region" {
  default     = "us-east-1"
  description = "Launch EC2 instance in this AWS region"
}
variable "type" {
  default     = "t2.micro"
  description = "EC2 instance type"
}
