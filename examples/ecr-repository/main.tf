provider "aws" {
  region = "ap-south-1"
  profile = "synergy-dev"
}

module "ecr" {
  source = "../../modules/ecs/ecr"
  created_by = "DevOps Team"
  env = "test"
  project_name = "terraform-modules"
}