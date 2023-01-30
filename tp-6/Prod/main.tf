provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-jules"
    key    =   "prod.tfstate"
    region = "us-east-1"
  }
}

module "ec2" {
  source = "../Modules/ec2_module"

  ins_type = "t2.micro"
  sg_name = "jules-prod-sg"
  tag_name = {
    Name = "ec2-prod-jules2"
  }
}

