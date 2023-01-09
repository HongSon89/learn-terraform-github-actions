terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "hongson89"

    workspaces {
      name = "hongson89-demo"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "demo" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = {
    Name = "Custom VPC"
  }
}

resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "demo security group"
  vpc_id      = aws_vpc.demo.id

}
resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["172.16.0.0/16"]
  security_group_id = aws_security_group.demo_sg.id
}
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  protocol          = "all"
  to_port           = "-1"
  from_port         = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.demo_sg.id
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.linux.id
  instance_type = data.aws_ec2_instance_type.type.instance_type
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  network_interface {
    network_interface_id = aws_network_interface.demo_networkinterface.id
    device_index         = 0
  }
  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_subnet" "demo_subnet" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = var.vpc_cidr_subnet

  tags = {
    Name = "Main"
  }
}
resource "aws_network_interface" "demo_networkinterface" {
  subnet_id   = aws_subnet.demo_subnet.id
  private_ips = [var.privateip]

  tags = {
    Name = "primary_network_interface"
  }
}