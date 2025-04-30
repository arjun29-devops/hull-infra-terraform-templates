provider "aws" {
  profile = "ocean-eye-prod"
  region  = "ap-south-1"
}
terraform {
  backend "s3" {
    bucket  = "ocean-eye-tfstate-prod"
    key     = "services/ocean-eye-hull-performance-alerts-api-prod/terraform.tfstate"
    region  = "ap-south-1"
    profile = "ocean-eye-prod"
  }
}
#resource "aws_ecs_cluster" "this" {
 # name = "ocean-eye-apps-cluster-prod"
#}
module "ecs" {
  cluster_name              = "ocean-eye-apps-cluster-prod"
  source                    = "../../../modules/services/ecs-existing-alb-app"
  alb_security_group_id     = "sg-071a0601e88ca5f7b"
  container_image           = "nginx"
  created_by                = "DevOps Team"
  env                       = local.env
  project_name              = local.project_name
  service_name              = local.project_name
  target_group_health_check = "/api/per/home/health"
  vpc_id                    = "vpc-066a62f5a37050652"
  ecs_subnet_ids            = ["subnet-02c8313cc63b86a8c", "subnet-0f00cee1b13c62af1", "subnet-058c5690d99ddcbe9"]
  alb_listener_arn          = "arn:aws:elasticloadbalancing:ap-south-1:339713047016:listener/app/ocean-eye-prod-alb/b18f797375cf46c1/ee684618b10e41fd"
  alb_path_based_listener   = "/api/per/*"
  #depends_on                = [aws_ecs_cluster.this]
  create_ecr_repo           = true
}
locals {
  project_name = "performance-alerts-api"
  env          = "prod"
}

