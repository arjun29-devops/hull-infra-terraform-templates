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
  description = "The Subnet IDs for the load balancer"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "created_by" {
  description = "Team who create the resource"
  type = string
}

variable "container_image" {
  description = "Image name for docker task"
  type = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type = string
}

variable "ecs_subnet_ids" {
  description = "Subnet IDs for the ECS service"
  type = list(string)
}

variable "target_group_health_check" {
  description = "Health check path for target group"
  type = string
}

variable "ssl_certificate_domain" {
  description = "Domain of the SSL certificate (Should in ISSUED status in AWS Certificate Manager)"
  type = string
}

variable "create_ecr_repo" {
  description = "Set false if want to create ECR repo default true"
  type = bool
  default = true
}