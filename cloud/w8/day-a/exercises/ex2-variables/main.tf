provider "aws" {
  region = "ap-southeast-1"
}


resource "aws_instance" "ec2_ex2" {
  ami           = "ami-0543dbdaf4e114be7"
  instance_type = var.instance_type
  tags          = var.common_tags
}
