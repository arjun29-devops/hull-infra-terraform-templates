terraform {
  required_version = ">=0.13, < 0.14"
}

  
resource "aws_launch_configuration" "app" {
  image_id = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.instance.id]
  key_name = var.key_pair
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name = "${ var.project_name }-${ var.environment }-${aws_launch_configuration.app.name}"

  launch_configuration = aws_launch_configuration.app.name
  vpc_zone_identifier = var.subnet_ids

  max_size = var.max_size
  min_size = var.min_size

  # Configurations with Load Balancer
  target_group_arns = var.target_group_arns
  health_check_type = var.health_check_type

  min_elb_capacity = var.min_size

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = ["Name", "Project"]
    content {
      key = tag.value
      value = var.project_name
      propagate_at_launch = true
    }
  }
}

resource "aws_security_group" "instance" {

  name = "${ var.project_name }-${ var.environment }-instance"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  from_port = var.server_port
  protocol = local.tcp_protocol
  security_group_id = aws_security_group.instance.id
  to_port = var.server_port
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.instance.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}


locals {
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}