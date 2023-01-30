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

  security_groups = ["${aws_security_group.allow_traffic.name}"]

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/julios/easytraining/boocamp_devops_terraform_tps/devops-jules.pem")
    host        = self.public_ip
  }

  root_block_device {
    delete_on_termination = true
  }
}

resource "aws_security_group" "allow_traffic" {
  name        = var.sg_name
  description = "Allow HTTP, HTTPS and SSH inbound traffic and all outbound traffic"

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
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.ec2_vm.id
  vpc      = true

  provisioner "local-exec" {
    command = "echo PUBLIC IP: ${aws_eip.lb.public_ip} >> infos_ec2.txt"
  }
}


