# Target Group for Private ALB

resource "aws_lb_target_group" "admin-target_group_private" {
  name        = "${var.ProjectName}-admin-tg-pri-${var.env}"
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

resource "aws_lb_listener_rule" "listener_rule_private" {
  depends_on = [
    aws_lb_target_group.admin-target_group_private
  ]
  listener_arn = var.listener_arn
  priority     = 105
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin-target_group_private.id
  }

  condition {
    path_pattern {
      values = ["/admin/*"]
    }
  }
}


