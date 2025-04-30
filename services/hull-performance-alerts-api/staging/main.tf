provider "aws" {
  profile = "hull-dev-test"
  region  = "ap-south-1"
}
terraform {
  backend "s3" {
    bucket  = "hull-devops-tfstate-stg"
    key     = "services/hull-performance-alerts-api-stg/terraform.tfstate"
    region  = "ap-south-1"
    profile = "hull-dev-test"
  }
}
#resource "aws_ecs_cluster" "this" {
 # name = "hull-common-apps-ecs-cluster-stg"
#}
module "ecs" {
  cluster_name              = "hull-common-apps-ecs-cluster-stg"
  source                    = "../../../modules/services/ecs-existing-alb-app"
  alb_security_group_id     = "sg-0df50aa0e1c620c35"
  container_image           = "nginx"
  created_by                = "DevOps Team"
  env                       = local.env
  project_name              = local.project_name
  service_name              = local.project_name
  target_group_health_check = "/api/per/Home/health"
  vpc_id                    = "vpc-0124c3021e12b1230"
  ecs_subnet_ids            = ["subnet-0560a24c444b926f5", "subnet-04cf1f7793d0ede8a"]
  alb_listener_arn          = "arn:aws:elasticloadbalancing:ap-south-1:676050803833:listener/app/hull-stg-alb/dbee4e662cf38720/12e734b5f05bbf23"
  alb_path_based_listener   = "/api/per/*"
 # depends_on                = [aws_ecs_cluster.this]
  create_ecr_repo           = true
}

locals {
  project_name = "hull-performance-alerts-api"
  env          = "stg"
}

