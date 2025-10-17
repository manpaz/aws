
variable "environment" {
  type        = string
  default     = "staging"
}

variable "organization" {
  type        = string
  default     = "bashlinux"
}

variable "az_count" {
  type        = number
  default     = 3
}

variable "ami_id" {
  type        = string
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
}

variable "domain" {
  type        = string
}

variable "deployer_ip" {
  type        = string
}

variable "deployer_name" {
  type        = string
}

variable "sg_common_id" {
  type        = string
}

# Additional variables for all modules
variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
  default     = ""
}

variable "public_key" {
  description = "Public key for SSH access"
  type        = string
  default     = ""
}

# ALB variables
variable "alb_listener_priority" {
  description = "Priority for ALB listener rules"
  type        = number
  default     = 100
}

# ECS variables
variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "api"
}

variable "ecs_task_cpu" {
  description = "CPU units for ECS task"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "Memory for ECS task in MB"
  type        = number
  default     = 512
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "ecs_listener_priority" {
  description = "Priority for ECS listener rule"
  type        = number
  default     = 200
}

variable "ecs_environment_variables" {
  description = "Environment variables for ECS containers"
  type        = list(map(string))
  default     = []
}

variable "ecs_environment_file_arn" {
  description = "ARN of the environment file in S3"
  type        = string
  default     = ""
}

# Fargate variables
variable "fargate_service_name" {
  description = "Name of the Fargate service"
  type        = string
  default     = "fargate-api"
}

variable "fargate_task_cpu" {
  description = "CPU units for Fargate task"
  type        = number
  default     = 256
}

variable "fargate_task_memory" {
  description = "Memory for Fargate task in MB"
  type        = number
  default     = 512
}

variable "fargate_desired_count" {
  description = "Desired number of Fargate tasks"
  type        = number
  default     = 1
}

variable "fargate_environment_variables" {
  description = "Environment variables for Fargate containers"
  type        = list(map(string))
  default     = []
}

# EKS variables
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "eks_instance_types" {
  description = "List of instance types for EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_desired_size" {
  description = "Desired number of EKS nodes"
  type        = number
  default     = 2
}

variable "eks_max_size" {
  description = "Maximum number of EKS nodes"
  type        = number
  default     = 4
}

variable "eks_min_size" {
  description = "Minimum number of EKS nodes"
  type        = number
  default     = 1
}

# RDS variables
variable "rds_engine" {
  description = "RDS engine"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "8.0.35"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "RDS maximum allocated storage in GB"
  type        = number
  default     = 100
}

variable "rds_storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp3"
}

variable "rds_storage_encrypted" {
  description = "Whether RDS storage is encrypted"
  type        = bool
  default     = true
}

variable "rds_kms_key_id" {
  description = "KMS key ID for RDS encryption"
  type        = string
  default     = ""
}

variable "rds_database_name" {
  description = "RDS database name"
  type        = string
  default     = "appdb"
}

variable "rds_username" {
  description = "RDS username"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "rds_port" {
  description = "RDS port"
  type        = number
  default     = 3306
}

variable "rds_publicly_accessible" {
  description = "Whether RDS is publicly accessible"
  type        = bool
  default     = false
}

variable "rds_backup_retention_period" {
  description = "RDS backup retention period in days"
  type        = number
  default     = 7
}

variable "rds_backup_window" {
  description = "RDS backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "rds_maintenance_window" {
  description = "RDS maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "rds_monitoring_interval" {
  description = "RDS monitoring interval in seconds"
  type        = number
  default     = 0
}

variable "rds_performance_insights_enabled" {
  description = "Whether RDS Performance Insights is enabled"
  type        = bool
  default     = false
}

variable "rds_performance_insights_retention_period" {
  description = "RDS Performance Insights retention period in days"
  type        = number
  default     = 7
}

variable "rds_deletion_protection" {
  description = "Whether RDS deletion protection is enabled"
  type        = bool
  default     = true
}

variable "rds_skip_final_snapshot" {
  description = "Whether to skip RDS final snapshot"
  type        = bool
  default     = false
}

variable "rds_multi_az" {
  description = "Whether RDS Multi-AZ is enabled"
  type        = bool
  default     = false
}

variable "rds_parameter_group_family" {
  description = "RDS parameter group family"
  type        = string
  default     = "mysql8.0"
}

variable "rds_parameters" {
  description = "RDS parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "rds_cluster_name" {
  description = "RDS cluster name"
  type        = string
  default     = "db01"
}

# DocumentDB variables
variable "documentdb_engine_version" {
  description = "DocumentDB engine version"
  type        = string
  default     = "4.0.0"
}

variable "documentdb_instance_class" {
  description = "DocumentDB instance class"
  type        = string
  default     = "db.t4g.medium"
}

variable "documentdb_instance_count" {
  description = "Number of DocumentDB instances"
  type        = number
  default     = 1
}

variable "documentdb_username" {
  description = "DocumentDB username"
  type        = string
  default     = "admin"
}

variable "documentdb_password" {
  description = "DocumentDB password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "documentdb_port" {
  description = "DocumentDB port"
  type        = number
  default     = 27017
}

variable "documentdb_backup_retention_period" {
  description = "DocumentDB backup retention period in days"
  type        = number
  default     = 7
}

variable "documentdb_backup_window" {
  description = "DocumentDB backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "documentdb_skip_final_snapshot" {
  description = "Whether to skip DocumentDB final snapshot"
  type        = bool
  default     = false
}

variable "documentdb_deletion_protection" {
  description = "Whether DocumentDB deletion protection is enabled"
  type        = bool
  default     = true
}

variable "documentdb_storage_encrypted" {
  description = "Whether DocumentDB storage is encrypted"
  type        = bool
  default     = true
}

variable "documentdb_kms_key_id" {
  description = "KMS key ID for DocumentDB encryption"
  type        = string
  default     = ""
}

variable "documentdb_parameter_group_family" {
  description = "DocumentDB parameter group family"
  type        = string
  default     = "docdb4.0"
}

variable "documentdb_parameters" {
  description = "DocumentDB parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "documentdb_cluster_name" {
  description = "DocumentDB cluster name"
  type        = string
  default     = "documentdb"
}

# ElastiCache variables
variable "elasticache_engine_version" {
  description = "ElastiCache engine version"
  type        = string
  default     = "7.0"
}

variable "elasticache_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t4g.micro"
}

variable "elasticache_num_cache_clusters" {
  description = "Number of ElastiCache cache clusters"
  type        = number
  default     = 2
}

variable "elasticache_num_cache_nodes" {
  description = "Number of ElastiCache cache nodes"
  type        = number
  default     = 1
}

variable "elasticache_port" {
  description = "ElastiCache port"
  type        = number
  default     = 6379
}

variable "elasticache_snapshot_retention_limit" {
  description = "ElastiCache snapshot retention limit"
  type        = number
  default     = 5
}

variable "elasticache_snapshot_window" {
  description = "ElastiCache snapshot window"
  type        = string
  default     = "03:00-05:00"
}

variable "elasticache_maintenance_window" {
  description = "ElastiCache maintenance window"
  type        = string
  default     = "sun:05:00-sun:07:00"
}

variable "elasticache_at_rest_encryption_enabled" {
  description = "Whether ElastiCache encryption at rest is enabled"
  type        = bool
  default     = true
}

variable "elasticache_transit_encryption_enabled" {
  description = "Whether ElastiCache encryption in transit is enabled"
  type        = bool
  default     = true
}

variable "elasticache_kms_key_id" {
  description = "KMS key ID for ElastiCache encryption"
  type        = string
  default     = ""
}

variable "elasticache_auth_token" {
  description = "ElastiCache auth token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "elasticache_multi_az_enabled" {
  description = "Whether ElastiCache Multi-AZ is enabled"
  type        = bool
  default     = false
}

variable "elasticache_automatic_failover_enabled" {
  description = "Whether ElastiCache automatic failover is enabled"
  type        = bool
  default     = false
}

variable "elasticache_use_cluster" {
  description = "Whether to use ElastiCache cluster instead of replication group"
  type        = bool
  default     = false
}

variable "elasticache_parameter_group_family" {
  description = "ElastiCache parameter group family"
  type        = string
  default     = "redis7.x"
}

variable "elasticache_parameters" {
  description = "ElastiCache parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "elasticache_cluster_name" {
  description = "ElastiCache cluster name"
  type        = string
  default     = "redis"
}

# ECR variables
variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "app"
}

variable "ecr_image_tag_mutability" {
  description = "ECR image tag mutability"
  type        = string
  default     = "MUTABLE"
}

variable "ecr_scan_on_push" {
  description = "Whether to scan ECR images on push"
  type        = bool
  default     = true
}

variable "ecr_encryption_type" {
  description = "ECR encryption type"
  type        = string
  default     = "AES256"
}

variable "ecr_kms_key_id" {
  description = "KMS key ID for ECR encryption"
  type        = string
  default     = ""
}

variable "ecr_max_image_count" {
  description = "Maximum number of ECR images to keep"
  type        = number
  default     = 10
}

variable "ecr_untagged_image_expiry_days" {
  description = "Number of days to keep untagged ECR images"
  type        = number
  default     = 7
}

variable "ecr_allowed_principals" {
  description = "List of AWS principals allowed to push/pull ECR images"
  type        = list(string)
  default     = ["*"]
}

variable "ecr_create_iam_role" {
  description = "Whether to create IAM role for ECR CI/CD"
  type        = bool
  default     = false
}

# S3 variables
variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = ""
}

variable "s3_public_access" {
  description = "Whether S3 bucket allows public access"
  type        = bool
  default     = false
}

variable "s3_versioning_enabled" {
  description = "Whether S3 versioning is enabled"
  type        = bool
  default     = true
}

variable "s3_encryption_algorithm" {
  description = "S3 encryption algorithm"
  type        = string
  default     = "AES256"
}

variable "s3_kms_key_id" {
  description = "KMS key ID for S3 encryption"
  type        = string
  default     = ""
}

variable "s3_bucket_key_enabled" {
  description = "Whether S3 bucket key is enabled"
  type        = bool
  default     = false
}

variable "s3_block_public_acls" {
  description = "Whether to block S3 public ACLs"
  type        = bool
  default     = true
}

variable "s3_block_public_policy" {
  description = "Whether to block S3 public policies"
  type        = bool
  default     = true
}

variable "s3_ignore_public_acls" {
  description = "Whether to ignore S3 public ACLs"
  type        = bool
  default     = true
}

variable "s3_restrict_public_buckets" {
  description = "Whether to restrict S3 public buckets"
  type        = bool
  default     = true
}

variable "s3_bucket_policy" {
  description = "S3 bucket policy JSON"
  type        = string
  default     = ""
}

variable "s3_cors_rules" {
  description = "List of S3 CORS rules"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = []
}

variable "s3_lifecycle_rules" {
  description = "List of S3 lifecycle rules"
  type = list(object({
    id                             = string
    status                         = string
    expiration                     = object({
      days = number
    })
    transitions                   = list(object({
      days          = number
      storage_class = string
    }))
    noncurrent_version_expiration = object({
      noncurrent_days = number
    })
  }))
  default = []
}

variable "s3_lambda_notifications" {
  description = "List of S3 Lambda notifications"
  type = list(object({
    lambda_function_arn = string
    events              = list(string)
    filter_prefix       = string
    filter_suffix       = string
  }))
  default = []
}

variable "s3_website_configuration" {
  description = "S3 website configuration"
  type = object({
    index_document = string
    error_document = string
  })
  default = null
}

variable "s3_logging_target_bucket" {
  description = "Target bucket for S3 logging"
  type        = string
  default     = ""
}

variable "s3_logging_target_prefix" {
  description = "Target prefix for S3 logging"
  type        = string
  default     = "logs/"
}

# Route53 variables
variable "route53_create_public_zone" {
  description = "Whether to create a public Route53 hosted zone"
  type        = bool
  default     = true
}

variable "route53_create_private_zone" {
  description = "Whether to create a private Route53 hosted zone"
  type        = bool
  default     = false
}

variable "route53_dns_records" {
  description = "Map of Route53 DNS records"
  type = map(object({
    name  = string
    type  = string
    ttl   = number
    records = list(string)
    alias = object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    })
  }))
  default = {}
}

variable "route53_health_checks" {
  description = "Map of Route53 health checks"
  type = map(object({
    fqdn                            = string
    port                            = number
    type                            = string
    resource_path                   = string
    failure_threshold               = number
    request_interval                = number
    cloudwatch_alarm_name           = string
    cloudwatch_alarm_region         = string
    insufficient_data_health_status = string
  }))
  default = {}
}

variable "route53_resolver_rules" {
  description = "Map of Route53 resolver rules"
  type = map(object({
    domain_name          = string
    name                 = string
    rule_type            = string
    resolver_endpoint_id = string
    target_ips = list(object({
      ip   = string
      port = number
    }))
  }))
  default = {}
}

variable "route53_resolver_rule_associations" {
  description = "Map of Route53 resolver rule associations"
  type = map(object({
    resolver_rule_id = string
    vpc_id          = string
  }))
  default = {}
}

variable "route53_create_certificate" {
  description = "Whether to create an ACM certificate"
  type        = bool
  default     = false
}

variable "route53_certificate_domain" {
  description = "Domain name for the ACM certificate"
  type        = string
  default     = ""
}

variable "route53_certificate_san_domains" {
  description = "Subject alternative names for the ACM certificate"
  type        = list(string)
  default     = []
}

variable "route53_certificate_validation_method" {
  description = "Validation method for the ACM certificate"
  type        = string
  default     = "DNS"
}
