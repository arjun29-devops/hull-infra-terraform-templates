provider "aws" {
  profile = "synergy-dev"
  region = "ap-south-1"
}

module "app" {
  source = "../../modules/services/ecs-alb-app"

  container_image = "460835339073.dkr.ecr.ap-south-1.amazonaws.com/synergy-apps-dev:crewwage"

  created_by = "DevOps Team"
  env = "test"
  project_name = "monolith"
  service_name = "httpd"

  alb_subnet_ids = [ "subnet-03e3e7038cb86088d", "subnet-0611e828bb22eda31" ]
  vpc_id = "vpc-06c5fe3a3999b33a8"
  ecs_subnet_ids = [ "subnet-0ff6fa7785cc42523"]
  target_group_health_check = "/swagger/index.html"

  ssl_certificate_domain = "synergymarinetest.com"
}

data "aws_subnet_ids" "public" {
  vpc_id = "vpc-056d246147bab3bf2"
}