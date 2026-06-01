resource "aws_instance" "ec2_module" {
  ami           = "ami-0543dbdaf4e114be7"
  instance_type = var.instance_type
  tags = {
    Name = var.server_name
  }
}
