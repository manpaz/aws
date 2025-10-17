output "common_sg_id" {
  description = "ID of the common security group"
  value       = aws_security_group.common.id
}

output "bastion_sg_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion.id
}

output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ecs_sg_id" {
  description = "ID of the ECS security group"
  value       = aws_security_group.ecs.id
}

output "eks_master_sg_id" {
  description = "ID of the EKS master security group"
  value       = aws_security_group.eks_master.id
}

output "eks_worker_sg_id" {
  description = "ID of the EKS worker security group"
  value       = aws_security_group.eks_worker.id
}

output "rds_sg_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "documentdb_sg_id" {
  description = "ID of the DocumentDB security group"
  value       = aws_security_group.documentdb.id
}

output "elasticache_sg_id" {
  description = "ID of the ElastiCache security group"
  value       = aws_security_group.elasticache.id
}

output "rabbitmq_sg_id" {
  description = "ID of the RabbitMQ security group"
  value       = aws_security_group.rabbitmq.id
}
