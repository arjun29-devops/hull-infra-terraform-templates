# variable file

# Service based variables changes required

variable "cloudwatch_group" {
  default = "receiver-logs-prod"
}

variable "serviceName" {
  default = "receiver-service-prod"
}

# ALB path priority
variable "service_priority" {
  default = 110
}

variable "cpu" {
  default = "256"
}

variable "memory" {
  default = "0.5GB"
}

variable "repository_uri" {
  default = "743515054768.dkr.ecr.ap-south-1.amazonaws.com/comm-svc-receiver-ecr-prod:latest"
}

variable "conatiner_port" {
  default = 80
}

variable "ecs_autoscale_max_to" {
  default = 2
}

variable "ecs_autoscale_min_to" {
  default = 1
}

# Partial Vars changes

# Private ALB Listner ARN
variable "listener_arn" {
  default = "arn:aws:elasticloadbalancing:ap-south-1:743515054768:listener/app/communication-svc-alb-pri-prod/1140f5fc3b86a593/e8d816facecea1d5"
}

variable "PathPattern" {
  default = "/notification/*"
}

variable "task_role_arn" {
  default = "arn:aws:iam::743515054768:role/communication-svc-ecs-task-role-prod"
}

variable "execution_role_arn" {
  default = "arn:aws:iam::743515054768:role/communication-svc-ecs-service-role-prod"
}

variable "cluster_name" {
  default = "communication-svc-ecs-cluster-prod"
}
variable "clusterARN" {
  default = "arn:aws:ecs:ap-south-1:743515054768:cluster/communication-svc-ecs-cluster-prod"
}

variable "ecs_service_role_arn" {
  default = "arn:aws:iam::743515054768:role/communication-svc-ecs-service-role-prod"
}

variable "PrivateSubnets" {
  default = ["subnet-05a2f6c5e6ed870d3", "subnet-0fff5f5b8fc578b2d"]
}

# Add ECS service SG or ALB SG
variable "alb_sg" {
  default = ["sg-0da9b7e7b868f482e"]
}

variable "pkg_receive_sg" {
  default = ["sg-0e76a9381b0b3d874"]
}

variable "ecs_autoscale_arn" {
  default = "arn:aws:iam::743515054768:role/communication-svc-ecs-autoscalling-role-prod"
}

variable "vpcId" {
  default = "vpc-0c921d4e36edb4e58"
}
