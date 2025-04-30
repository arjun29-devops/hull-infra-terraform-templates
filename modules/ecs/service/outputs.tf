output "target_group_arn" {
  description = "ARN of the load balancer target group"
  value = aws_lb_target_group.alb.arn
}

output "ecs_sg" {
  description = "Security group ID of ECS task"
  value = aws_security_group.ecs_sg.id
}