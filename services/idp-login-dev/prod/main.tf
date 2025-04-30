provider "aws" {
  profile = "hull-dev-test"
  region  = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket  = "ocean-eye-prod-tfstate-master"
    key     = "services/ocean-eye-idp-login-prod/terraform.tfstate"
    region  = "ap-southeast-1"
    profile = "hull-dev-test"
  }
}
 resource "aws_ecs_cluster" "this" {
 name = "ocean-eye-prod-cluster-apps"
 }
module "ecs" {
  cluster_name              = aws_ecs_cluster.this.name
  source                    = "../../../modules/services/ecs-existing-alb-app"
  alb_security_group_id     = "sg-0e63c106b5888bb4c"
  container_image           = "nginx"
  created_by                = "DevOps Team"
  env                       = local.env
  project_name              = local.project_name
  service_name              = local.project_name
  target_group_health_check = "/health/ping"
  vpc_id                    = "vpc-0ed1414ddcf7c4431"
  ecs_subnet_ids            = ["subnet-0c6db5b12ae45e03e", "subnet-0f479d5d6aed90021", "subnet-063b9ee61d05e4e68"]
  alb_listener_arn          = "arn:aws:elasticloadbalancing:ap-southeast-1:676050803833:listener/app/ocean-eye-prod-alb/6876185ddea581f1/a6ad4a07afe95523"
  alb_path_based_listener   = "/health/ping/*"
  depends_on                = [aws_ecs_cluster.this]
  create_ecr_repo           = true
}

locals {
  project_name = "ocean-eye-login-idp"
  env          = "prod"
}

