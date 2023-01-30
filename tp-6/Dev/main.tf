provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-jules"
    key    = "dev.tfstate"
    region = "us-east-1"
  }
}

module "ec2" {
  source = "../Modules/ec2_module"

  ins_type = "t2.nano"
  sg_name = "jules-dev-sg"
  tag_name = {
    Name = "ec2-dev-jules2"
  }
}
