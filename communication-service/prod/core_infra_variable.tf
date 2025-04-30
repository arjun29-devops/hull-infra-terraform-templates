variable "comm_svc_ecs_container_port" {
  default = 80
}

variable "PublicSubnets" {
  default = ["subnet-064cd7a703817c028", "subnet-0504ffc05e87d0e49"]
}

variable "PrivateSubnets" {
  default = ["subnet-05a2f6c5e6ed870d3", "subnet-0fff5f5b8fc578b2d"]
}

variable "vpcId" {
  default = "vpc-0c921d4e36edb4e58"
}