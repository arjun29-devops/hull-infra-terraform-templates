# ALB SG
resource "aws_security_group" "alb_sg_appcentralapps" {
  name   = "${var.ProjectName}-alb-sg-appcentralapps-${var.env}"
  vpc_id = var.vpcId

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.ProjectName}-alb-sg-appcentralapps-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}
