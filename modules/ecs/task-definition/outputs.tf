output "task_definition_arn" {
  description = "ARN of the task created definition"
  value = aws_ecs_task_definition.task_definition.arn
}

