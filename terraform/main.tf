terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.9.8"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "flask_ecr" {
  name                 = "clo835-assignment1-flask"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "sql_ecr" {
  name                 = "clo835-assignment1-sql"
  image_tag_mutability = "MUTABLE"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Get the first available subnet from the default VPC
data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}

# Get IAM Instance Profile
data "aws_iam_instance_profile" "ec2_profile" {
  name = var.iam_role
}

# Creating Web App Instance
resource "aws_instance" "flask_app" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = "vockey"
  security_groups             = [aws_security_group.Web_SG.id]
  subnet_id                   = data.aws_subnet.default.id
  associate_public_ip_address = true
  user_data                   = file("userdata.sh")
  iam_instance_profile        = data.aws_iam_instance_profile.ec2_profile.name
  tags = {
    "Name" = "Flask_App"
  }
}

# Security group for Web App
resource "aws_security_group" "Web_SG" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "Web_SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.Web_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8081
  ip_protocol       = "tcp"
  to_port           = 8083
  description       = "Allow HTTP from Anywhere"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.Web_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH from Anywhere"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.Web_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}