output "ecs_sg" {
  description = "Security group ID of ECS task"
  value = module.ecs-service.ecs_sg
}