# create ALB - Public

resource "aws_lb" "application_lb" {
  name               = "${var.ProjectName}-alb-pub-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg_appcentralapps.id]
  subnets            = var.PublicSubnets

  # enable_deletion_protection = true

  tags = {
    Name        = "${var.ProjectName}-alb-pub-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

# Target Group for Public ALB

resource "aws_lb_target_group" "ecs-target_group" {
  name        = "${var.ProjectName}-tg-pub-${var.env}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpcId
}

# ALB listners Rules

resource "aws_lb_listener_rule" "listener_rule" {
  depends_on = [
    aws_lb_target_group.ecs-target_group
  ]
  listener_arn = aws_lb_listener.alb_listners.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-target_group.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

# ALB listners

resource "aws_lb_listener" "alb_listners" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::123456789012:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-target_group.arn
  }

  depends_on = [
    aws_lb_target_group.ecs-target_group
  ]
}
