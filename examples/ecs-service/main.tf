provider "aws" {
  region  = "ap-south-1"
  profile = "synergy-dev"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${local.project_name}-${local.env}"
}

module "autoscaling_iam_role" {
  source                = "../../modules/iam/role"
  assuming_role_service = "ecs.amazonaws.com"
  created_by            = local.created_by
  env                   = local.env
  project_name          = local.project_name
  role_name             = "ecs_service_role"
  role_policy_file      = "ecs_service_role"
}

module "ecs-service" {
  source                   = "../../modules/ecs/service/"
  cloudwatch_group         = "${local.project_name}-${local.env}"
  container_name           = "web"
  container_port           = "80"
  created_by               = local.created_by
  ecs_cluster_arn          = aws_ecs_cluster.cluster.arn
  ecs_max_capacity         = 1
  ecs_min_capacity         = 1
  env                      = local.env
  iam_role_arn_autoscaling = module.autoscaling_iam_role.iam_role_arn
  private_subnet           = data.aws_subnet_ids.default.ids
  project_name             = local.project_name
  service_name             = "web"
  task_definition_Arn      = "arn:aws:ecs:ap-south-1:460835339073:task-definition/web:3"
  vpc_id                   = data.aws_subnet_ids.default.vpc_id
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "arn:aws:elasticloadbalancing:ap-south-1:460835339073:loadbalancer/app/test-alb-terraform-lb/3e7e3e38a8e2bea4"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = module.ecs-service.target_group_arn
  }
}

data "aws_subnet_ids" "default" {
  vpc_id = "vpc-056d246147bab3bf2"
}

locals {
  created_by     = "DevOps Team"
  env            = "test"
  project_name   = "terraform-modules"
  container_name = "nginx"
}