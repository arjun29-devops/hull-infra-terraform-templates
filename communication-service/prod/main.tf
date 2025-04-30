provider "aws" {
  profile = "synergy-devops-stg"
  region  = "ap-south-1"
  version = "~> 3.1.0"
}

terraform {
  backend "s3" {
    bucket  = "synergy-devops-tfstate-prod"
    key     = "communication-service/terraform.tfstate"
    region  = "ap-south-1"
    profile = "synergy-devops-stg"
  }
}

variable "ProjectName" {
  default = "communication-svc"
}

variable "CreatedBy" {
  default = "synergy-devops"
}

variable "env" {
  default = "prod"
}

variable "rds_username" {
  default = "synergy"
}

# We can apply original pass from run time
variable "rds_password" {
  default = "xxxxxxx"
}

variable "sg_ports" {
  type        = list(number)
  description = "list of ports"
  default     = [80, 443, 22]
}

variable "rule_no" {
  type = map
  default = {
    "80"  = "100"
    "443" = "101"
    "22"  = "102"
  }
}
