output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.main.id
}

output "db_instance_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.main.arn
}

output "db_instance_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_address" {
  description = "Address of the RDS instance"
  value       = aws_db_instance.main.address
}

output "db_instance_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.main.port
}

output "db_instance_name" {
  description = "Name of the RDS instance"
  value       = aws_db_instance.main.name
}

output "db_instance_username" {
  description = "Username of the RDS instance"
  value       = aws_db_instance.main.username
}

output "db_subnet_group_id" {
  description = "ID of the DB subnet group"
  value       = aws_db_subnet_group.main.id
}

output "db_parameter_group_id" {
  description = "ID of the DB parameter group"
  value       = aws_db_parameter_group.main.id
}
