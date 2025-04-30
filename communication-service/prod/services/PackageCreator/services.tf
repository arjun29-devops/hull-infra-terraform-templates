# Create a CW log group for ECS task

resource "aws_cloudwatch_log_group" "ECS_log_group" {
  name = var.cloudwatch_group

  tags = {
    Name        = "cw-lg-${var.serviceName}-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

# ELB Listner Rule entry for service

resource "aws_lb_listener_rule" "service_targetGroup_listnerRule" {
  listener_arn = var.listener_arn
  priority     = var.service_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pkg-create-target_group.arn
  }

  condition {
    path_pattern {
      values = [var.PathPattern]
    }
  }
}

# ECS task defination

resource "aws_ecs_task_definition" "service_task_defination" {
  family                = var.serviceName
  container_definitions = file("${var.serviceName}.json")

  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name        = "ecs-task-${var.serviceName}-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

# ECS service

resource "aws_ecs_service" "pkg-create_service_ecs" {
  name            = "${var.serviceName}-${var.env}"
  cluster         = var.clusterARN
  task_definition = aws_ecs_task_definition.service_task_defination.arn
  desired_count   = 1
  # iam_role                          = var.ecs_service_role_arn
  health_check_grace_period_seconds = 60
  launch_type                       = "FARGATE"

  network_configuration {
    subnets          = var.PrivateSubnets
    security_groups  = var.pkg_create_sg
    assign_public_ip = "false"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pkg-create-target_group.arn
    container_name   = var.serviceName
    container_port   = var.conatiner_port
  }
  load_balancer {
    #target_group_arn = aws_lb_target_group.pkg-create-target_group_private.arn
    target_group_arn = aws_lb_target_group.pkg-create-target_group_private.arn
    container_name   = var.serviceName
    container_port   = var.conatiner_port
  }

  depends_on = [
    aws_lb_target_group.pkg-create-target_group,
    aws_lb_target_group.pkg-create-target_group_private
  ]
}

# ECS Autoscaling target

resource "aws_appautoscaling_target" "ecs_target_autoscale" {
  max_capacity       = var.ecs_autoscale_max_to
  min_capacity       = var.ecs_autoscale_min_to
  resource_id        = "service/${var.cluster_name}/${var.serviceName}-${var.env}"
  role_arn           = var.ecs_autoscale_arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [
    aws_ecs_service.pkg-create_service_ecs
  ]
}
