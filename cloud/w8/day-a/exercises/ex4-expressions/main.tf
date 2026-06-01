provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "ec2_ex4" {
  for_each      = var.environments
  ami           = "ami-0543dbdaf4e114be7"
  instance_type = each.key == "prod" ? "t3.micro" : "t3.small"
  tags = {
    Name = "${local.project_name}-${each.key}-ec2"
  }
}

locals {
  project_name = "ex4-expressions"
}
