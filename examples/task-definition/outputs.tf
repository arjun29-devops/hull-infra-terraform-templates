output "task_definition_arn" {
  description = "ARN of the task created definition"
  value = module.ecs-task-definition.task_definition_arn
}