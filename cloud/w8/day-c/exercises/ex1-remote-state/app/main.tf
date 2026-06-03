# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bucket-b94382f0"
#     key            = "app/terraform.tfstate"
#     region         = "ap-southeast-1"
#     dynamodb_table = "terraform-state-locks"
#     encrypt        = true
#   }
# }

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0543dbdaf4e114be7"
  instance_type = "t3.micro"
  tags = {
    Name = "RemoteStateAppServer-Updated"
  }
}
