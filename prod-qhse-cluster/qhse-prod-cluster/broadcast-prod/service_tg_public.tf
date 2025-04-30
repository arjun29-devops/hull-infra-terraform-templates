# Target Group for Public ALB

resource "aws_lb_target_group" "qhse-broadcast-target_group" {
  name        = "qhse-broadcast-tg-pub-${var.env}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpcId

  health_check {
    path                = "/qhse/broadcast/home/ping"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 3
    interval            = 5
    matcher             = "200-302" # has to be HTTP 200 or fails
  }
}
