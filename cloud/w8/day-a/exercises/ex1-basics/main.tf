provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "ec2_ex1" {
  ami           = "ami-0543dbdaf4e114be7"
  instance_type = "t3.micro"

  tags = {
    Name = "ec2_ex1_terraform-updated-2"
  }
}
