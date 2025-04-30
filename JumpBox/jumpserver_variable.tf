
variable "bastion_security_group" {
  default = ["sg-0fd015fdfc35a2c29"]
}

variable "bastion_subnets" {
  default = "subnet-0bb62eb4186efd870"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ami" {
  default = "ami-0db0b3ab7df22e366"
}

variable "key_name" {
  default = "synergyapps-bastion-stg"
}
