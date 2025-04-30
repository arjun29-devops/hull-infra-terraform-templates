provider "aws" {
  profile = "synergy-prod"
  region  = "ap-south-1"
  version = "~> 3.1.0"
}

terraform {
  backend "s3" {
    bucket  = "synergy-devops-tfstate-prod"
    key     = "qhse/broadcast/terraform.tfstate"
    region  = "ap-south-1"
    profile = "synergy-prod"
  }
}

variable "ProjectName" {
  default = "app-central-apps"
}

variable "CreatedBy" {
  default = "synergy-devops"
}

variable "env" {
  default = "prod"
}
