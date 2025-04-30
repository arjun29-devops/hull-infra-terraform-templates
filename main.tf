provider "aws" {
  profile = "synergy-devops-stg"
  region  = "ap-south-1"
  version = "~> 3.1.0"
}

terraform {
  backend "s3" {
    bucket  = "synergy-devops-tfstate-stg"
    key     = "terraform.tfstate"
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

variable "rds_username" {
  default = "synergy"
}

# We can apply original pass from run time
variable "rds_password" {
  default = "xaUytAyVfat66hPv"
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
