provider "aws" {
  profile = "synergy-devops-stg"
  region  = "ap-south-1"
}
terraform {
  backend "s3" {
    bucket  = "synergy-devops-tfstate-prod"
    key     = "services/common-apps-prod/manning-po-api/terraform.tfstate"
    region  = "ap-south-1"
    profile = "synergy-devops-stg"
  }
}
resource "aws_ecs_cluster" "this" {
  name = "common-apps-ecs-cluster-prod"
}
module "ecs" {
  cluster_name              = aws_ecs_cluster.this.name
  source                    = "../../../modules/services/ecs-existing-alb-app"
  alb_security_group_id     = "sg-08d2c893cc73c086d"
  container_image           = "nginx"
  created_by                = "DevOps Team"
  env                       = local.env
  project_name              = local.project_name
  service_name              = local.project_name
  target_group_health_check = "/manning-po/v1/health"
  vpc_id                    = "vpc-0c921d4e36edb4e58"
  ecs_subnet_ids            = ["subnet-05a2f6c5e6ed870d3", "subnet-0fff5f5b8fc578b2d", "subnet-074c782b4d574dfed"]
  alb_listener_arn          = "arn:aws:elasticloadbalancing:ap-south-1:743515054768:listener/app/app-central-apps-alb-pub-prod/051bb7c351c3e2b7/b64a5777d6099778"
  alb_path_based_listener   = "/manning-po/*"
  depends_on                = [aws_ecs_cluster.this]
  create_ecr_repo           = true
}
locals {
  project_name = "manning-po-api"
  env          = "prod"
}
