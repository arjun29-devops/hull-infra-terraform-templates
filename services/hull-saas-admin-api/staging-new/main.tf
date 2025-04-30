provider "aws" {
  profile = "hull-dev-test"
  region  = "ap-south-1"
}
terraform {
  backend "s3" {
    bucket  = "ocean-eye-tfstate-stag"
    key     = "services/hull-saas-admin-api-stg/terraform.tfstate"
    region  = "ap-south-1"
    profile = "hull-dev-test"
  }
}
#resource "aws_ecs_cluster" "this" {
 # name = "hull-common-apps-ecs-cluster-stg"
#}
module "ecs" {
  cluster_name              = "ocean-eye-common-apps-ecs-cluster-staging"
  source                    = "../../../modules/services/ecs-existing-alb-app"
  alb_security_group_id     = "sg-0170cb4558ea4b1ed"
  container_image           = "nginx"
  created_by                = "DevOps Team"
  env                       = local.env
  project_name              = local.project_name
  service_name              = local.project_name
  target_group_health_check = "/api/saas/home/health"
  vpc_id                    = "vpc-00fd8e939e2206691"
  ecs_subnet_ids            = ["subnet-0235b7c1da2864fab", "subnet-003d016854abdfc46"]
  alb_listener_arn          = "arn:aws:elasticloadbalancing:ap-south-1:676050803833:listener/app/ocean-eye-staging/fc45705512ff4a3b/87a4cabe9b5dac5e"
  alb_path_based_listener   = "/api/saas/*"
 # depends_on                = [aws_ecs_cluster.this]
  create_ecr_repo           = true
}

locals {
  project_name = "hull-saas-admin"
  env          = "stag"
}

