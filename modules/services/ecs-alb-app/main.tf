
module "alb" {
  source = "../../../modules/networking/lb"
  alb_subnet_ids = var.alb_subnet_ids
  env = var.env
  project_name = var.project_name
  vpc_id = var.vpc_id
}

module "task-role" {
  source = "../../../modules/iam/role"
  assuming_role_service = "ecs-tasks.amazonaws.com"
  created_by = var.created_by
  env = var.env
  project_name = var.project_name
  role_policy_file = "task_role_policy"
  role_name = "task-role"
}

module "execution-role" {
  source = "../../../modules/iam/role"
  assuming_role_service = "ecs-tasks.amazonaws.com"
  created_by = var.created_by
  env = var.env
  project_name = var.project_name
  role_policy_file = "execution_role_policy"
  role_name = "execution-role"
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
}

module "ecr" {
  count = var.create_ecr_repo ? 1 : 0
  source = "../../../modules/ecs/ecr"
  created_by = var.created_by
  env = var.env
  project_name = var.project_name
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-${var.env}"
}

module "autoscaling_iam_role" {
  source                = "../../../modules/iam/role"
  assuming_role_service = "ecs.amazonaws.com"
  created_by            = var.created_by
  env                   = var.env
  project_name          = var.project_name
  role_name             = "ecs_service_role"
  role_policy_file      = "ecs_service_role"
}


module "ecs-service" {
  source                   = "../../../modules/ecs/service/"
  cloudwatch_group         = "${var.project_name}-${var.env}"
  container_name           = var.project_name
  container_port           = "80"
  created_by               = var.created_by
  ecs_cluster_arn          = aws_ecs_cluster.cluster.arn
  ecs_max_capacity         = 1
  ecs_min_capacity         = 1
  env                      = var.env
  iam_role_arn_autoscaling = module.autoscaling_iam_role.iam_role_arn
  project_name             = var.project_name
  service_name             = var.service_name
  task_definition_Arn      = module.ecs-task-definition.task_definition_arn
  vpc_id                   = var.vpc_id
  alb_security_group_id = module.alb.alb_security_group_id
  ecs_subnet_ids = var.ecs_subnet_ids
  target_group_health_check = var.target_group_health_check
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = module.alb.alb_arn
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = module.ecs-service.target_group_arn
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = module.alb.alb_arn
  port              = 443
  protocol = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn = data.aws_acm_certificate.ssl_certificate.arn
  default_action {
    type             = "forward"
    target_group_arn = module.ecs-service.target_group_arn
  }
}

resource "aws_security_group_rule" "https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = module.alb.alb_security_group_id
  to_port = 443
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

data "aws_acm_certificate" "ssl_certificate" {
  domain = var.ssl_certificate_domain
  statuses = ["ISSUED"]
}