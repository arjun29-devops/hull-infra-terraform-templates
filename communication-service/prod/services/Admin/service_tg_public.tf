# Target Group for Public ALB

resource "aws_lb_target_group" "admin-target_group" {
  name        = "${var.ProjectName}-admin-tg-pub-${var.env}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpcId

  health_check {
    path                = "/admin/health"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 3
    interval            = 5
    matcher             = "200-302" # has to be HTTP 200 or fails
  }
}

# ALB listners Rules

resource "aws_lb_listener_rule" "listener_rule_public" {
  depends_on = [
    aws_lb_target_group.admin-target_group
  ]
  listener_arn = var.listener_arn_pub
  priority     = 105
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin-target_group.id
  }

  condition {
    path_pattern {
      values = ["/admin/*"]
    }
  }
}

