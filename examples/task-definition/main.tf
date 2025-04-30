provider "aws" {
  region = "ap-south-1"
  profile = "synergy-dev"
}

module "task-role" {
  source = "../../modules/iam/role"
  assuming_role_service = "ecs-tasks.amazonaws.com"
  created_by = local.created_by
  env = local.env
  project_name = local.project_name
  role_policy_file = "task_role_policy"
  role_name = "task-role"
}

module "execution-role" {
  source = "../../modules/iam/role"
  assuming_role_service = "ecs-tasks.amazonaws.com"
  created_by = local.created_by
  env = local.env
  project_name = local.project_name
  role_policy_file = "execution_role_policy"
  role_name = "execution-role"
}

module "ecs-task-definition" {
  source = "../../modules/ecs/task-definition"
  container_name = "web"
  container_port = "80"
  created_by = local.created_by
  env = local.env
  execution_role_arn = module.execution-role.iam_role_arn
  project_name = local.project_name
  service_name = "web"
  task_role_arn = module.task-role.iam_role_arn
  container_image = "httpd"
}

locals {
  created_by = "DevOps Team"
  env = "test"
  project_name = "terraform-modules"
}