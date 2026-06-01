provider "aws" {
  region = "ap-southeast-1"
}

# Using count

# resource "aws_instance" "ec2_loop" {
#   count         = length(var.envName)
#   ami           = "ami-0543dbdaf4e114be7"
#   instance_type = "t3.micro"

#   tags = {
#     Name = "ec2_loop_Web-Server-${count.index}"
#   }
# }

# Using for_each

resource "aws_instance" "ec2_loop" {
  for_each      = var.envName
  ami           = "ami-0543dbdaf4e114be7"
  instance_type = "t3.micro"

  tags = {
    Name = "ec2_loop_Server-${each.value}"
  }
}
