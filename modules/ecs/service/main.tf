# Create a CW log group for ECS task

resource "aws_cloudwatch_log_group" "ecs" {
  name = var.cloudwatch_group

  tags = {
    Name        = "${ var.project_name }-${var.service_name }-${var.env}"
    ProjectName = var.project_name
    CreatedBy   = var.created_by
  }
}

# ECS service

resource "aws_ecs_service" "app" {
  name                              = var.service_name
  cluster                           = data.aws_ecs_cluster.app.arn
  task_definition                   = var.task_definition_Arn
  desired_count                     = var.desired_count
  health_check_grace_period_seconds = 60
  launch_type                       = "FARGATE"
  network_configuration {
    subnets          = var.ecs_subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = "true"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [
    aws_lb_target_group.alb
  ]
}

resource "aws_lb_target_group" "alb" {
  name        = "${var.project_name }-${var.env}"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path                = var.target_group_health_check
    port                = var.container_port
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 3
    interval            = 5
    matcher             = "200-302" # has to be HTTP 200 or fails
  }
}
# ECS Autoscaling target


resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.ecs_max_capacity
  min_capacity       = var.ecs_min_capacity
  resource_id = "service/${ var.cluster_name }/${ aws_ecs_service.app.name }"
#  resource_id        = "service/${ var.project_name }-${var.env}/${ aws_ecs_service.app.name }"
  role_arn           = var.iam_role_arn_autoscaling
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [
    aws_ecs_service.app
  ]
}

data "aws_ecs_cluster" "app" {
  cluster_name = var.cluster_name
}
