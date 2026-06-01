provider "aws" {
  region = "ap-southeast-1"
}

module "app1" {
  source        = "./modules/ec2-instance"
  server_name   = "web-FrontEnd"
  instance_type = "t3.micro"
}

module "app2" {
  source        = "./modules/ec2-instance"
  server_name   = "db-BackEnd"
  instance_type = "t3.micro"
}
