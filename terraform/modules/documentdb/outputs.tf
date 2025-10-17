output "cluster_id" {
  description = "ID of the DocumentDB cluster"
  value       = aws_docdb_cluster.main.id
}

output "cluster_arn" {
  description = "ARN of the DocumentDB cluster"
  value       = aws_docdb_cluster.main.arn
}

output "cluster_endpoint" {
  description = "Endpoint of the DocumentDB cluster"
  value       = aws_docdb_cluster.main.endpoint
}

output "cluster_port" {
  description = "Port of the DocumentDB cluster"
  value       = aws_docdb_cluster.main.port
}

output "cluster_reader_endpoint" {
  description = "Reader endpoint of the DocumentDB cluster"
  value       = aws_docdb_cluster.main.reader_endpoint
}

output "cluster_instances" {
  description = "List of DocumentDB cluster instances"
  value       = aws_docdb_cluster_instance.main[*].id
}

output "subnet_group_id" {
  description = "ID of the DocumentDB subnet group"
  value       = aws_docdb_subnet_group.main.id
}

output "parameter_group_id" {
  description = "ID of the DocumentDB parameter group"
  value       = aws_docdb_cluster_parameter_group.main.id
}
