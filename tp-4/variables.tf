variable "ins_type" {
  default = "t2.nano"
  type    = string
}
variable "tag_name" {
  default = {
    Name = "ec2-jules"
  }
  type = map(any)
}

