# ECS task definition

resource "aws_ecs_task_definition" "task_definition" {
  family                = "${ var.project_name }-${ var.env }"
  container_definitions = data.template_file.task_definition.rendered
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name        = "ecs-task-${var.service_name}-${var.env}"
    ProjectName = var.project_name
    CreatedBy   = var.created_by
  }
}

data "template_file" "task_definition" {
  template = file("./task-definition.json")
  vars = {
    container_name = var.container_name
    image_name = var.container_image
    project_name = var.project_name
    env = var.env
  }
}
