provider "aws" {
  profile = "synergy-devops-stg"
  region  = "ap-south-1"
  version = "~> 3.1.0"
}

terraform {
  backend "s3" {
    bucket  = "synergy-devops-tfstate-stg"
    key     = "bastion_terraform.tfstate"
    region  = "ap-south-1"
    profile = "synergy-devops-stg"
  }
}

variable "ProjectName" {
  default = "synergy-apps"
}

variable "CreatedBy" {
  default = "synergy-devops"
}

variable "env" {
  default = "stg"
}
