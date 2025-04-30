

module "task-role" {
  source = "../../../modules/iam/role"
  assuming_role_service = "ecs-tasks.amazonaws.com"
  created_by = var.created_by
  env = var.env
  project_name = var.project_name
  role_name = "task-role"
  additional_permissions = []
}


module "execution-role" {
  source = "../../../modules/iam/role"
  assuming_role_service = "ecs-tasks.amazonaws.com"
  env = var.env
  project_name = var.project_name
  role_name = "execution-role"
  additional_permissions = ["ssm:*"]
}

module "ecs-task-definition" {
  source = "../../../modules/ecs/task-definition"
  container_name = var.service_name
  container_port = "80"
  created_by = var.created_by
  env = var.env
  execution_role_arn = module.execution-role.iam_role_arn
  project_name = var.project_name
  service_name = var.service_name
  task_role_arn = module.task-role.iam_role_arn
  container_image = var.container_image
  cpu = var.cpu
  memory = var.memory
}

module "ecr" {
  count = var.create_ecr_repo ? 1 : 0
  source = "../../../modules/ecs/ecr"
  created_by = var.created_by
  env = var.env
  project_name = var.project_name
}


module "autoscaling_iam_role" {
  source                = "../../../modules/iam/role"
  assuming_role_service = "ecs.amazonaws.com"
  env                   = var.env
  project_name          = var.project_name
  role_name             = "ecs-service-role"
  additional_permissions = ["ecs:*"]
}


module "ecs-service" {
  source                   = "../../../modules/ecs/service/"
  cloudwatch_group         = "${var.project_name}-${var.env}"
  container_name           = var.project_name
  container_port           = var.container_port
  created_by               = var.created_by
  cluster_name        = var.cluster_name
  ecs_max_capacity         = 1
  ecs_min_capacity         = 1
  env                      = var.env
  iam_role_arn_autoscaling = module.autoscaling_iam_role.iam_role_arn
  project_name             = var.project_name
  service_name             = var.service_name
  task_definition_Arn      = module.ecs-task-definition.task_definition_arn
  vpc_id                   = var.vpc_id
  alb_security_group_id = var.alb_security_group_id
  ecs_subnet_ids = var.ecs_subnet_ids
  target_group_health_check = var.target_group_health_check
  desired_count = var.desired_count
}


resource "aws_lb_listener_rule" "alb_listener_rule_host_based" {
  count = length(var.alb_host_based_listener) > 0 ? 1 : 0
  listener_arn = var.alb_listener_arn
  action {
    type             = "forward"
    target_group_arn = module.ecs-service.target_group_arn
  }
  condition {
    host_header {
      values = [ var.alb_host_based_listener ]
    }
  }
}

resource "aws_lb_listener_rule" "alb_listener_rule_path_based" {
  count = length(var.alb_path_based_listener) > 0 ? 1 : 0
  listener_arn = var.alb_listener_arn
  action {
    type             = "forward"
    target_group_arn = module.ecs-service.target_group_arn
  }
  condition {
    path_pattern {
      values = [var.alb_path_based_listener]
    }
  }
}