# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "project_name" {
  description = "The name to use of all cluster resources { Recommended format: app-name_environment } e.g. terraform_staging"
  type = string
}

variable "env" {
  description = "Environment in which application is supposed to be deployed e.g dev/staging/prod"
  type = string
}

variable "created_by" {
  description = "Team who create the resource"
  type = string
}

variable "cloudwatch_group" {
  description = "Name of the cloudwatch group for the ECS task"
  type = string
}

variable "service_name" {
  description = "Name of the ecs service"
  type = string
}

variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type = string
}

variable "target_group_health_check" {
  description = "Health check path for target group"
  type = string
}

variable "ecs_subnet_ids" {
  description = "Subnet IDs for the ECS service"
  type = list(string)
}

variable "container_name" {
  description = "Name for the ECS container"
  type = string
}

variable "container_port" {
  description = "Port of the ecs container"
  type = number
}

variable "ecs_min_capacity" {
  description = "Minimum number of container ECS should scale to"
  type = number
}

variable "ecs_max_capacity" {
  description = "Maximum number of container ECS required"
  type = number
}

variable "iam_role_arn_autoscaling" {
  description = "IAM role arn for autoscaling group"
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "cluster_name" {
  description = "ECS cluster name for the ecs service"
  type = string
}

variable "task_definition_Arn" {
  description = "Task definition arn for the ecs service"
  type = string
}

variable "desired_count" {
  description = "Desired number of tasks"
  default = 1
}
# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "target_group_port"{
  description = "Port on which application is serving { default: 80 }"
  type = number
  default = 80
}
