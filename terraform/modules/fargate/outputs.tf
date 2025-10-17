output "cluster_id" {
  description = "ID of the Fargate cluster"
  value       = aws_ecs_cluster.fargate.id
}

output "cluster_arn" {
  description = "ARN of the Fargate cluster"
  value       = aws_ecs_cluster.fargate.arn
}

output "service_id" {
  description = "ID of the Fargate service"
  value       = aws_ecs_service.fargate.id
}

output "service_arn" {
  description = "ARN of the Fargate service"
  value       = aws_ecs_service.fargate.arn
}

output "task_definition_arn" {
  description = "ARN of the Fargate task definition"
  value       = aws_ecs_task_definition.fargate.arn
}

output "task_execution_role_arn" {
  description = "ARN of the Fargate task execution role"
  value       = aws_iam_role.fargate_task_execution_role.arn
}

output "task_role_arn" {
  description = "ARN of the Fargate task role"
  value       = aws_iam_role.fargate_task_role.arn
}
