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

variable "service_name" {
  description = "Name of the ecs service"
}

variable "task_role_arn" {
  description = "IAM task role arn for ECS service"
  type = string
}

variable "execution_role_arn" {
  description = "IAM task role arn for ECS service"
  type = string
}

variable "container_name" {
  description = "Name for the ECS container"
  type = string
}

variable "container_port" {
  description = "Port of the ecs container"
  type = number
}

variable "container_image" {
  description = "Image name for docker task"
  type = string
}
# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "cpu" {
  description = "CPU of the ECS task {default: 256}"
  default = "256"
}

variable "memory" {
  description = "RAM of the ECS task {default: 0.5GB}"
  default = "512"
}

variable "network_mode" {
  description = "Network mode for the ECS cluster {default: awsvpc}"
  default = "awsvpc"
}

