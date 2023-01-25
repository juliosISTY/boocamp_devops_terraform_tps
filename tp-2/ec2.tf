provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAQJSIZEB2LHNSLRBZ"
  secret_key = "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"
}

resource "aws_instance" "ec2_vm" {
  ami           = "ami-012cc038cc685a0d7"
  instance_type = "t2.micro"
  key_name      = "devops-jules"
  tags = {
    Name = "ec2-jules"
  }
  root_block_device {
    delete_on_termination = true
  }
}

