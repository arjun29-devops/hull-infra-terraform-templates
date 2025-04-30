# ECS SG's

# Survey Service SG : Connect to Public LB
resource "aws_security_group" "ecs_sg_qhse_survey" {
  name   = "${var.ProjectName}-ecs-sg-qhse-survey-${var.env}"
  vpc_id = var.vpcId

  ingress {
    from_port       = var.qhse_survey_ecs_container_port
    to_port         = var.qhse_survey_ecs_container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg_appcentralapps.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.ProjectName}-ecs-sg-qhse-survey-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

# Broadcast Service SG : Connect to Public LB
resource "aws_security_group" "ecs_sg_qhse_broadcast" {
  name   = "${var.ProjectName}-ecs-sg-qhse-broadcast-${var.env}"
  vpc_id = var.vpcId

  ingress {
    from_port       = var.qhse_broadcast_ecs_container_port
    to_port         = var.qhse_broadcast_ecs_container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg_appcentralapps.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.ProjectName}-ecs-sg-qhse-broadcast-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}
