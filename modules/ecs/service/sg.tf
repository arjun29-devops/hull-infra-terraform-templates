

# ECS Service SG
resource "aws_security_group" "ecs_sg" {
  name   = "${var.project_name }-ecs-sg-${var.env}"
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name }-ecs-sg-${var.env}"
    ProjectName = var.project_name
    CreatedBy   = var.created_by
  }
}