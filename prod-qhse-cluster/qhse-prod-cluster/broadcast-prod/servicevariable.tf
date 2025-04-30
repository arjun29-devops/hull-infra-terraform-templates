# variable file

# Service based variables changes required

variable "cloudwatch_group" {
  default = "qhse-broadcast-prod-logs"
}

variable "serviceName" {
  default = "qhse-broadcast-service"
}

# ALB path priority
variable "service_priority" {
  default = 114
}

variable "cpu" {
  default = "256"
}

variable "memory" {
  default = "0.5GB"
}

variable "repository_uri" {
  default = "743515054768.dkr.ecr.ap-south-1.amazonaws.com/app-central-apps-prod:broadcast"
}

variable "conatiner_port" {
  default = 80
}

variable "ecs_autoscale_max_to" {
  default = 20
}

variable "ecs_autoscale_min_to" {
  default = 1
}

# Partial Vars changes

# Private ALB Listner ARN
variable "listener_arn" {
  default = "arn:aws:elasticloadbalancing:ap-south-1:743515054768:listener/app/app-central-apps-alb-pub-prod/051bb7c351c3e2b7/561c4814a1d2e663"
}

variable "PathPattern" {
  default = "/qhse/broadcast/*"
}

variable "task_role_arn" {
  default = "arn:aws:iam::743515054768:role/app-central-apps-ecs-task-role-prod"
}

variable "execution_role_arn" {
  default = "arn:aws:iam::743515054768:role/app-central-apps-ecs-service-role-prod"
}

variable "cluster_name" {
  default = "app-central-apps-ecs-cluster-prod"
}
variable "clusterARN" {
  default = "arn:aws:ecs:ap-south-1:743515054768:cluster/app-central-apps-ecs-cluster-prod"
}

variable "ecs_service_role_arn" {
  default = "arn:aws:iam::743515054768:role/app-central-apps-ecs-service-role-prod"
}

variable "PrivateSubnets" {
  default = ["subnet-05a2f6c5e6ed870d3", "subnet-0fff5f5b8fc578b2d", "subnet-074c782b4d574dfed"]
}

# Add ECS service SG or ALB SG
variable "alb_sg" {
  default = ["sg-08d2c893cc73c086d"]
}

variable "qhse-broadcast_sg" {
  default = ["sg-031a937e17f2ab725"]
}

variable "ecs_autoscale_arn" {
  default = "arn:aws:iam::743515054768:role/app-central-apps-ecs-autoscalling-role-prod"
}

variable "vpcId" {
  default = "vpc-0c921d4e36edb4e58"
}

