# Install AWS module
terraform {
  required_providers {
    aws = "~> 2.44"
  }
  required_version = "~> 0.12"
}

# Read local files
locals {
  user_data = templatefile(var.template, local.user_vars)
  user_vars = {
    awslogs = "/home/${var.user}/awslogs.json"
    install = file(var.install)
    launch  = file(var.launch)
    script  = "/home/${var.user}/${basename(var.launch)}"
    name    = var.name
    user    = var.user
  }
}

# Upload public SSH key to AWS
resource "aws_key_pair" "ec2box" {
  key_name   = var.name
  public_key = file(var.public_key)
}

# Create CloudWatch Log group
resource "aws_cloudwatch_log_group" "ec2box" {
  name              = var.name
  retention_in_days = 365
}

# Assign EC2 firewall rules
resource "aws_security_group" "ec2box" {
  description = "Allow SSH login and all outbound connections"
  name        = var.name

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
}

# Perform IAM rituals
resource "aws_iam_role" "ec2box" {
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  description        = "${var.name} permissions"
  name               = var.name
}
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}
resource "aws_iam_role_policy" "ec2box" {
  name   = aws_iam_role.ec2box.name
  role   = aws_iam_role.ec2box.id
  policy = data.aws_iam_policy_document.ec2box.json
}
data "aws_iam_policy_document" "ec2box" {
  source_json = file(var.policy)
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}
resource "aws_iam_instance_profile" "ec2box" {
  name = aws_iam_role.ec2box.name
  role = aws_iam_role.ec2box.id
}

# Rent a computer
resource "aws_instance" "ec2box" {
  ami                  = var.ami
  iam_instance_profile = aws_iam_instance_profile.ec2box.name
  instance_type        = var.ec2type
  key_name             = aws_key_pair.ec2box.key_name
  security_groups      = [aws_security_group.ec2box.name]
  tags                 = { Name = var.name }
  user_data            = local.user_data
  volume_tags          = { Name = var.name }

  root_block_device {
    volume_size = var.diskgb
  }
}