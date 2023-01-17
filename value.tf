data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

data "aws_ec2_instance_type" "type" {
  instance_type = "t2.micro"
}

variable "vpc_cidr_block" {
  description = "VPC Demo CIDR"
  default     = "10.1.0.0/16"
}
variable "vpc_cidr_subnet" {
  description = "VPC Demo subnet"
  default     = "10.1.0.0/24"
}
variable "privateip" {
  description = "privateip"
<<<<<<< HEAD
  default     = "10.1.0.211"
=======
  default     = "10.1.0.100"
>>>>>>> parent of 8dcac33 (tao thich)
}