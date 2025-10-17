output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.main.repository_url
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.main.arn
}

output "registry_id" {
  description = "Registry ID of the ECR repository"
  value       = aws_ecr_repository.main.registry_id
}

output "repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.main.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role for CI/CD"
  value       = var.create_iam_role ? aws_iam_role.ecr_push_pull[0].arn : null
}
