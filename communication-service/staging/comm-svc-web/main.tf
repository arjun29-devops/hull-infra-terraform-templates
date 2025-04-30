provider "aws" {
  profile = "synergy-prod"
  region  = "ap-south-1"
  version = "~> 3.1.0"
}

provider "aws" {
  alias = "virginia"
  profile = "synergy-prod"
  region  = "us-east-1"
  version = "~> 3.1.0"
}

terraform {
  backend "s3" {
    bucket  = "synergy-devops-tfstate-prod"
    key     = "communication-service/staging/comm-svc-web/terraform.tfstate"
    region  = "ap-south-1"
    profile = "synergy-prod"
  }
}

module "web" {
  source = "../../../modules/static-cdn"
  bucket_name = "comm-svc-web-${ local.env }"
  created_by = "DevOps Team"
  domain_alias = "staging-ai-communication.synergymarine.in"
  env = local.env
  project_name = local.project_name
  ssl_certificate_arn = data.aws_acm_certificate.ssl.arn
}

locals {
  env = "staging"
  project_name = "comm-svc-web"
}

data "aws_acm_certificate" "ssl" {
  provider = aws.virginia
  domain = "*.synergymarine.in"
}