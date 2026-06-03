provider "aws" {
  region = "ap-southeast-1"
}

module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  env      = "dev"
}

