variable "ami" {
  default     = "ami-04b9e92b5572fa0d1"
  description = "Amazon Machine Image ID"
}
variable "diskgb" {
  default     = "8"
  description = "Root volume size (GB)"
}
variable "ec2type" {
  default     = "t3.micro"
  description = "EC2 instance type"
}
variable "name" {
  default     = "ec2box"
  description = "Name tag for resources"
}
variable "install" {
  default     = "etc/install"
  description = "Path to install script"
}
variable "launch" {
  default     = "etc/launch"
  description = "Path to launch script"
}
variable "policy" {
  default     = "etc/policy.json"
  description = "Path to IAM policy JSON file"
}
variable "public_key" {
  default     = "etc/ec2box_rsa.pub"
  description = "Path to public SSH key"
}
variable "template" {
  default     = "etc/cloud-init"
  description = "Path to cloud-init template file"
}
variable "user" {
  default     = "ubuntu"
  description = "Login as this user"
}
