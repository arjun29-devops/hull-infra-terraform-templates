# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "project_name" {
  description = "The name to use of all project resources { Recommended format: app-name_environment } e.g. terraform_staging"
  type = string
}

variable "env" {
  description = "Environment in which application is supposed to be deployed e.g dev/staging/prod"
  type = string
}

variable "alb_subnet_ids" {
  description = "The Subnet IDs to deploy to"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}