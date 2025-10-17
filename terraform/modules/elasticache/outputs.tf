output "replication_group_id" {
  description = "ID of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.main.id
}

output "replication_group_arn" {
  description = "ARN of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.main.arn
}

output "replication_group_primary_endpoint_address" {
  description = "Primary endpoint address of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "replication_group_reader_endpoint_address" {
  description = "Reader endpoint address of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.main.reader_endpoint_address
}

output "replication_group_port" {
  description = "Port of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.main.port
}

output "cluster_id" {
  description = "ID of the ElastiCache cluster"
  value       = var.use_cluster ? aws_elasticache_cluster.main[0].id : null
}

output "cluster_endpoint" {
  description = "Endpoint of the ElastiCache cluster"
  value       = var.use_cluster ? aws_elasticache_cluster.main[0].cache_nodes[0].address : null
}

output "subnet_group_id" {
  description = "ID of the ElastiCache subnet group"
  value       = aws_elasticache_subnet_group.main.id
}

output "parameter_group_id" {
  description = "ID of the ElastiCache parameter group"
  value       = aws_elasticache_parameter_group.main.id
}
