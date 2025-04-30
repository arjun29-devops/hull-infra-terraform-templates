provider "aws" {
  region = "ap-south-1"
  profile = "synergy-dev"
}

module "iam-role" {
  source = "../../modules/iam/role"
  assuming_role_service = "ecs-tasks.amazonaws.com"
  created_by = "DevOps Team"
  env = "example"
  project_name = "example"
  role_policy_file = "role_policy"
  role_name = "example-ecs-service-policy-example"
}