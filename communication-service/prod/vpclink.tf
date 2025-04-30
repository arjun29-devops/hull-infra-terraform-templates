# Create VPC link, attach Private ALB

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "${var.ProjectName}-vpclink-${var.env}"
  security_group_ids = [aws_security_group.sec-grps["Alb-SG"].id]
  subnet_ids         = var.PrivateSubnets

  tags = {
    Name        = "${var.ProjectName}-vpclink-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}
