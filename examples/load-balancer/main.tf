provider "aws" {
  region = "ap-south-1"
   profile = "synergy-dev"
}

module "alb" {
  source = "../../modules/networking/lb"

  subnet_ids = data.aws_subnet_ids.default.ids
  env = "terraform-lb"
  project_name = "test"
  vpc_id = "vpc-056d246147bab3bf2"
}


data "aws_subnet_ids" "default" {
  vpc_id = "vpc-056d246147bab3bf2"
}