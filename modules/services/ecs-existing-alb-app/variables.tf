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


variable "alb_security_group_id" {
  description = "Security group id of ALB"
  type = string
}

variable "alb_listener_arn" {
  description = "ALB listener arn"
  type = string
}


variable "cluster_name" {
  description = "ECS cluster name for the ecs service"
  type = string
}

variable "alb_host_based_listener" {
  description = "Add this variables for the host based listener in alb"
  type = string
  default = ""
}

variable "alb_path_based_listener" {
  description = "Add this variables for the path based listener in alb"
  type = string
  default = ""
}

variable "create_ecr_repo" {
  description = "Set true if want to create ECR repo"
  type = bool
  default = false
}

variable "container_port" {
  description = "Port of the ecs container { default 80 }"
  type = number
  default = 80
}

variable "cpu" {
  description = "CPU of the ECS task {default: 256}"
  default = "256"
}

variable "memory" {
  description = "RAM of the ECS task {default: 0.5GB}"
  default = "512"
}

variable "desired_count" {
  description = "Desired number of tasks"
  default = 1
}