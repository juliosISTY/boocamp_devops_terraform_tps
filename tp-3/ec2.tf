provider "aws" {
  region     = "us-east-1"
  access_key = "aws_access_key"
  secret_key = "aws_secret_key"
}

data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "ec2_vm" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.ins_type
  key_name      = "devops-jules"
  tags          = var.tag_name

  security_groups = ["${aws_security_group.allow_http_https.name}"]

  root_block_device {
    delete_on_termination = true
  }
}

resource "aws_security_group" "allow_http_https" {
  name        = "jules-sg"
  description = "Allow HTTP and HTTPS inbound traffic"

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.ec2_vm.id
  vpc      = true
}

