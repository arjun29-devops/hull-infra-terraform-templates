provider "aws" {
  profile = "hull-dev-test"
  region  = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket  = "hull-idp-tfstate-dev"
    key     = "services/hull-idp-tfstate-dev/terraform.tfstate"
    region  = "ap-south-1"
    profile = "hull-dev-test"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "hull-idp-ecs-cluster-dev"
}
module "ecs" {
  cluster_name              = aws_ecs_cluster.this.name
  source                    = "../../../modules/services/ecs-existing-alb-app"
  alb_security_group_id     = "sg-070fb1eefe055c38c"
  container_image           = "nginx"
  created_by                = "DevOps Team"
  env                       = local.env
  project_name              = local.project_name
  service_name              = local.project_name
  target_group_health_check = "/v1/v1/health"
  vpc_id                    = "vpc-0b0c5cb770bdaf445"
  ecs_subnet_ids            = ["subnet-0968b8383f8c092ce", "subnet-01aaa66ae8cb1a030"]
  alb_listener_arn          = "arn:aws:elasticloadbalancing:ap-south-1:676050803833:listener/app/hull-dev-alb/c00b254950895b6d/9b7a638f7b7f1d7d"
  alb_path_based_listener   = "/v1/v1/*"
  depends_on                = [aws_ecs_cluster.this]
  create_ecr_repo           = true
}

locals {
  project_name = "idp-admin-api-dev"
  env          = "dev"
}
