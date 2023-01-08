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

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

}
resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["172.16.0.0/16"]
  security_group_id = aws_security_group.allow_tls.id
}
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  protocol          = "all"
  to_port           = "-1"
  from_port         = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_tls.id
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.linux.id
  instance_type = data.aws_ec2_instance_type.type.instance_type
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }
  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_subnet" "vpb_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "Main"
  }
}
resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.vpb_subnet.id
  private_ips = ["10.1.1.100"]

  tags = {
    Name = "primary_network_interface"
  }
}