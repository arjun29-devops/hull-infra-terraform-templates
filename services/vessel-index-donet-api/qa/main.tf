provider "aws" {
  profile = "hull-dev-test"
  region  = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket  = "hull-devops-tfstate-qa"
    key     = "services/vessel-index-dotnet-api-qa/terraform.tfstate"
    region  = "ap-south-1"
    profile = "hull-dev-test"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "vessel-common-apps-ecs-cluster-qa"
}
module "ecs" {
  cluster_name              = aws_ecs_cluster.this.name
  source                    = "../../../modules/services/ecs-existing-alb-app"
  alb_security_group_id     = "sg-01d99cb2da3d19872"
  container_image           = "nginx"
  created_by                = "DevOps Team"
  env                       = local.env
  project_name              = local.project_name
  service_name              = local.project_name
  target_group_health_check = "/v1/v1/health"
  vpc_id                    = "vpc-0750e62e513aaeb9e"
  ecs_subnet_ids            = ["subnet-0a1d7594a83eb7b5a", "subnet-0c15e2404500f2272"]
  alb_listener_arn          = "arn:aws:elasticloadbalancing:ap-south-1:676050803833:listener/app/hull-qa-alb/fb85a9036ab20d70/d5f98578c9044689"
  alb_path_based_listener   = "/v1/v1/*"
  depends_on                = [aws_ecs_cluster.this]
  create_ecr_repo           = true
}

locals {
  project_name = "vessel-index-dotnet-api"
  env          = "qa"
}
