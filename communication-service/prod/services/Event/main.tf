provider "aws" {
  profile = "synergy-devops-stg"
  region  = "ap-south-1"
  version = "~> 3.1.0"
}

terraform {
  backend "s3" {
    bucket  = "synergy-devops-tfstate-prod"
    key     = "communication-service/event/terraform.tfstate"
    region  = "ap-south-1"
    profile = "synergy-devops-stg"
  }
}

variable "ProjectName" {
  default = "comm-svc"
}

variable "CreatedBy" {
  default = "synergy-devops"
}

variable "env" {
  default = "prod"
}
