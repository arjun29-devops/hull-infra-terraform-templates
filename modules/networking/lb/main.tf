terraform {
  required_version = ">=0.13, < 0.14"
}

resource "aws_lb" "app" {
  name = "${var.project_name}-alb-${ var.env }"
  load_balancer_type = "application"
  subnets = var.alb_subnet_ids
  security_groups = [aws_security_group.lb.id]
}

resource "aws_security_group" "lb" {
  name = "${var.project_name }-alb-sg-${ var.env }"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  from_port = local.http_port
  protocol = local.tcp_protocol
  security_group_id = aws_security_group.lb.id
  to_port = local.http_port
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_http_outbound" {
  type = "egress"
  from_port = local.http_port
  protocol = local.tcp_protocol
  security_group_id = aws_security_group.lb.id
  to_port = local.http_port
  cidr_blocks = local.all_ips
}


locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}