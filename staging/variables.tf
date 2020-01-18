
variable "amis" {
  default = {
    "eu-west-1" = "ami-0713f98de93617bb4"
    "us-east-1" = "ami-062f7200baf2fa504"
    "us-west-1" = "ami-03caa3f860895f82e"
  }
  description = "Amazon Machine Image for each region"
}
variable "ec2user" {
  default     = "ec2-user"
  description = "Run launch script as this user"
}
variable "gb" {
  default     = "8"
  description = "Root volume size (GB)"
}
variable "name" {
  default     = "ec2box"
  description = "Name tag for ec2box"
}
variable "profile" {
  default     = "default"
  description = "AWS profile from ~/.aws/credentials"
}
variable "region" {
  default     = "us-east-1"
  description = "Launch ec2box in this AWS region"
}
variable "script" {
  default     = "launch"
  description = "Run this script when launching an ec2box"
}
variable "type" {
  default     = "t3.micro"
  description = "EC2 instance type"
}
