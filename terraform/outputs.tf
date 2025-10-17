
# Network outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.network.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.network.private_subnet_ids
}

# Bastion outputs
output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = module.ec2_bastion.public_ip
}

output "bastion_private_ip" {
  description = "Private IP of the bastion host"
  value       = module.ec2_bastion.private_ip
}

output "bastion_dns_name" {
  description = "DNS name of the bastion host"
  value       = module.ec2_bastion.dns_name
}

# ALB outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = module.alb.alb_zone_id
}

# ECS outputs
output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "ecs_service_id" {
  description = "ID of the ECS service"
  value       = module.ecs.service_id
}

# Fargate outputs
output "fargate_cluster_id" {
  description = "ID of the Fargate cluster"
  value       = module.fargate.cluster_id
}

output "fargate_service_id" {
  description = "ID of the Fargate service"
  value       = module.fargate.service_id
}

# EKS outputs
output "eks_cluster_id" {
  description = "ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

# RDS outputs
output "rds_instance_id" {
  description = "ID of the RDS instance"
  value       = module.rds.db_instance_id
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.rds.db_instance_endpoint
}

# DocumentDB outputs
output "documentdb_cluster_id" {
  description = "ID of the DocumentDB cluster"
  value       = module.documentdb.cluster_id
}

output "documentdb_endpoint" {
  description = "Endpoint of the DocumentDB cluster"
  value       = module.documentdb.cluster_endpoint
}

# ElastiCache outputs
output "elasticache_replication_group_id" {
  description = "ID of the ElastiCache replication group"
  value       = module.elasticache.replication_group_id
}

output "elasticache_primary_endpoint" {
  description = "Primary endpoint of the ElastiCache replication group"
  value       = module.elasticache.replication_group_primary_endpoint_address
}

# ECR outputs
output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

# S3 outputs
output "s3_bucket_id" {
  description = "ID of the S3 bucket"
  value       = module.s3.bucket_id
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = module.s3.bucket_domain_name
}

# Route53 outputs
output "route53_public_zone_id" {
  description = "ID of the public hosted zone"
  value       = module.route53.public_zone_id
}

output "route53_private_zone_id" {
  description = "ID of the private hosted zone"
  value       = module.route53.private_zone_id
}

output "route53_certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = module.route53.certificate_arn
}
