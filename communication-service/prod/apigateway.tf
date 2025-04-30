# Create HTTP API Gateway
resource "aws_apigatewayv2_api" "api_gw" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"
  description   = "API Gateway"
}

# Create a Route for API Gateway
resource "aws_apigatewayv2_route" "api_gw_route" {
  api_id = aws_apigatewayv2_api.api_gw.id
  #route_key = "$default"
  route_key = "GET /"
}

# API Gateway Integration
resource "aws_apigatewayv2_integration" "api_gw_integration" {
  api_id      = aws_apigatewayv2_api.api_gw.id
  description = "Private Resource"
  #integration_type    = "AWS_PROXY"
  integration_type   = "HTTP_PROXY"
  integration_method = "GET"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id
  #integration_subtype = ""
  integration_uri = aws_lb_listener.alb_listners_private.arn
}

# API Gateway Stage
resource "aws_apigatewayv2_stage" "api_gw_stage" {
  api_id = aws_apigatewayv2_api.api_gw.id
  name   = "$default"
}
