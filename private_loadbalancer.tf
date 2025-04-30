# create ALB - Private

resource "aws_lb" "application_lb_private" {
  name               = "${var.ProjectName}-alb-pri-${var.env}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sec-grps["Alb-SG"].id]
  subnets            = [aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_1.id]

  # enable_deletion_protection = true

  tags = {
    Name        = "${var.ProjectName}-alb-pri-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

# Target Group for Public ALB

resource "aws_lb_target_group" "ecs-target_group_private" {
  name        = "${var.ProjectName}-tg-pri-${var.env}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
}

# ALB listners Rules

resource "aws_lb_listener_rule" "listener_rule_private_lb" {
  depends_on = [
    aws_lb_target_group.ecs-target_group_private
  ]
  listener_arn = aws_lb_listener.alb_listners_private.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-target_group_private.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

# ALB listners

resource "aws_lb_listener" "alb_listners_private" {
  load_balancer_arn = aws_lb.application_lb_private.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::123456789012:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-target_group_private.arn
  }

  depends_on = [
    aws_lb_target_group.ecs-target_group_private
  ]
}
