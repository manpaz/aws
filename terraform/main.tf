
# Data Sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Network Module
module "network" {
  source        = "../modules/network"
  environment   = var.environment
  organization  = var.organization
  az_count      = var.az_count
  default_tags  = local.default_tags
}

# Security Groups Module
module "security_groups" {
  source         = "../modules/security_groups"
  vpc_id         = module.network.vpc_id
  vpc_cidr       = module.network.vpc_cidr
  sg_common_id   = var.sg_common_id
  deployer_ip    = var.deployer_ip
  deployer_name  = var.deployer_name
  default_tags   = local.default_tags
  environment    = var.environment
  organization   = var.organization
}

# EC2 Bastion Module
module "ec2_bastion" {
  source              = "../modules/ec2_bastion"
  vpc_id              = module.network.vpc_id
  subnet_id           = module.network.public_subnet_1a_id
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  public_key          = var.public_key
  deployer_ip         = var.deployer_ip
  domain              = var.domain
  hosted_zone_id      = module.network.private_hosted_zone_id
  default_tags        = local.default_tags
  environment         = var.environment
  organization        = var.organization
}

# ALB Module
module "alb" {
  source              = "../modules/alb"
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.public_subnet_ids
  security_group_ids  = [module.security_groups.alb_sg_id]
  certificate_arn     = var.certificate_arn
  listener_priority   = var.alb_listener_priority
  default_tags        = local.default_tags
  environment         = var.environment
  organization        = var.organization
}

# ECS Module
module "ecs" {
  source              = "../modules/ecs"
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.private_subnet_ids
  security_group_ids  = [module.security_groups.ecs_sg_id]
  service_name        = var.ecs_service_name
  task_cpu            = var.ecs_task_cpu
  task_memory         = var.ecs_task_memory
  desired_count       = var.ecs_desired_count
  target_group_arn    = module.alb.ecs_target_group_arn
  listener_arn         = module.alb.https_listener_arn
  listener_priority    = var.ecs_listener_priority
  environment_variables = var.ecs_environment_variables
  environment_file_arn = var.ecs_environment_file_arn
  account_id          = data.aws_caller_identity.current.account_id
  aws_region          = data.aws_region.current.name
  default_tags        = local.default_tags
  environment         = var.environment
  organization        = var.organization
}

# Fargate Module
module "fargate" {
  source              = "../modules/fargate"
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.private_subnet_ids
  security_group_ids  = [module.security_groups.ecs_sg_id]
  service_name        = var.fargate_service_name
  task_cpu            = var.fargate_task_cpu
  task_memory         = var.fargate_task_memory
  desired_count       = var.fargate_desired_count
  target_group_arn    = module.alb.ecs_target_group_arn
  environment_variables = var.fargate_environment_variables
  account_id          = data.aws_caller_identity.current.account_id
  aws_region          = data.aws_region.current.name
  default_tags        = local.default_tags
  environment         = var.environment
  organization        = var.organization
}

# EKS Module
module "eks" {
  source              = "../modules/eks"
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.private_subnet_ids
  security_group_ids  = [module.security_groups.eks_master_sg_id, module.security_groups.eks_worker_sg_id]
  kubernetes_version  = var.kubernetes_version
  instance_types      = var.eks_instance_types
  desired_size        = var.eks_desired_size
  max_size            = var.eks_max_size
  min_size            = var.eks_min_size
  default_tags        = local.default_tags
  environment         = var.environment
  organization        = var.organization
}

# RDS Module
module "rds" {
  source              = "../modules/rds"
  subnet_ids          = module.network.private_subnet_ids
  security_group_ids  = [module.security_groups.rds_sg_id]
  engine              = var.rds_engine
  engine_version      = var.rds_engine_version
  instance_class      = var.rds_instance_class
  allocated_storage   = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  storage_type        = var.rds_storage_type
  storage_encrypted   = var.rds_storage_encrypted
  kms_key_id         = var.rds_kms_key_id
  database_name       = var.rds_database_name
  username           = var.rds_username
  password           = var.rds_password
  port               = var.rds_port
  publicly_accessible = var.rds_publicly_accessible
  backup_retention_period = var.rds_backup_retention_period
  backup_window      = var.rds_backup_window
  maintenance_window = var.rds_maintenance_window
  monitoring_interval = var.rds_monitoring_interval
  performance_insights_enabled = var.rds_performance_insights_enabled
  performance_insights_retention_period = var.rds_performance_insights_retention_period
  deletion_protection = var.rds_deletion_protection
  skip_final_snapshot = var.rds_skip_final_snapshot
  multi_az           = var.rds_multi_az
  parameter_group_family = var.rds_parameter_group_family
  parameters         = var.rds_parameters
  cluster_name       = var.rds_cluster_name
  default_tags       = local.default_tags
  environment        = var.environment
  organization       = var.organization
}

# DocumentDB Module
module "documentdb" {
  source              = "../modules/documentdb"
  subnet_ids          = module.network.private_subnet_ids
  security_group_ids  = [module.security_groups.documentdb_sg_id]
  engine_version      = var.documentdb_engine_version
  instance_class      = var.documentdb_instance_class
  instance_count      = var.documentdb_instance_count
  username           = var.documentdb_username
  password           = var.documentdb_password
  port               = var.documentdb_port
  backup_retention_period = var.documentdb_backup_retention_period
  backup_window      = var.documentdb_backup_window
  skip_final_snapshot = var.documentdb_skip_final_snapshot
  deletion_protection = var.documentdb_deletion_protection
  storage_encrypted  = var.documentdb_storage_encrypted
  kms_key_id         = var.documentdb_kms_key_id
  parameter_group_family = var.documentdb_parameter_group_family
  parameters         = var.documentdb_parameters
  cluster_name       = var.documentdb_cluster_name
  default_tags       = local.default_tags
  environment        = var.environment
  organization       = var.organization
}

# ElastiCache Module
module "elasticache" {
  source              = "../modules/elasticache"
  subnet_ids          = module.network.private_subnet_ids
  security_group_ids  = [module.security_groups.elasticache_sg_id]
  engine_version      = var.elasticache_engine_version
  node_type          = var.elasticache_node_type
  num_cache_clusters = var.elasticache_num_cache_clusters
  num_cache_nodes    = var.elasticache_num_cache_nodes
  port               = var.elasticache_port
  snapshot_retention_limit = var.elasticache_snapshot_retention_limit
  snapshot_window    = var.elasticache_snapshot_window
  maintenance_window = var.elasticache_maintenance_window
  at_rest_encryption_enabled = var.elasticache_at_rest_encryption_enabled
  transit_encryption_enabled = var.elasticache_transit_encryption_enabled
  kms_key_id         = var.elasticache_kms_key_id
  auth_token         = var.elasticache_auth_token
  multi_az_enabled   = var.elasticache_multi_az_enabled
  automatic_failover_enabled = var.elasticache_automatic_failover_enabled
  use_cluster        = var.elasticache_use_cluster
  parameter_group_family = var.elasticache_parameter_group_family
  parameters         = var.elasticache_parameters
  cluster_name       = var.elasticache_cluster_name
  default_tags       = local.default_tags
  environment        = var.environment
  organization       = var.organization
}

# ECR Module
module "ecr" {
  source              = "../modules/ecr"
  repository_name     = var.ecr_repository_name
  image_tag_mutability = var.ecr_image_tag_mutability
  scan_on_push        = var.ecr_scan_on_push
  encryption_type     = var.ecr_encryption_type
  kms_key_id         = var.ecr_kms_key_id
  max_image_count     = var.ecr_max_image_count
  untagged_image_expiry_days = var.ecr_untagged_image_expiry_days
  allowed_principals  = var.ecr_allowed_principals
  create_iam_role     = var.ecr_create_iam_role
  default_tags        = local.default_tags
  environment         = var.environment
  organization        = var.organization
}

# S3 Module
module "s3" {
  source              = "../modules/s3"
  bucket_name         = var.s3_bucket_name
  public_access       = var.s3_public_access
  versioning_enabled  = var.s3_versioning_enabled
  encryption_algorithm = var.s3_encryption_algorithm
  kms_key_id         = var.s3_kms_key_id
  bucket_key_enabled  = var.s3_bucket_key_enabled
  block_public_acls  = var.s3_block_public_acls
  block_public_policy = var.s3_block_public_policy
  ignore_public_acls = var.s3_ignore_public_acls
  restrict_public_buckets = var.s3_restrict_public_buckets
  bucket_policy      = var.s3_bucket_policy
  cors_rules         = var.s3_cors_rules
  lifecycle_rules    = var.s3_lifecycle_rules
  lambda_notifications = var.s3_lambda_notifications
  website_configuration = var.s3_website_configuration
  logging_target_bucket = var.s3_logging_target_bucket
  logging_target_prefix = var.s3_logging_target_prefix
  default_tags       = local.default_tags
  environment        = var.environment
  organization       = var.organization
}

# Route53 Module
module "route53" {
  source              = "../modules/route53"
  domain_name        = var.domain
  vpc_id             = module.network.vpc_id
  create_public_zone = var.route53_create_public_zone
  create_private_zone = var.route53_create_private_zone
  dns_records        = var.route53_dns_records
  health_checks      = var.route53_health_checks
  resolver_rules     = var.route53_resolver_rules
  resolver_rule_associations = var.route53_resolver_rule_associations
  create_certificate = var.route53_create_certificate
  certificate_domain = var.route53_certificate_domain
  certificate_san_domains = var.route53_certificate_san_domains
  certificate_validation_method = var.route53_certificate_validation_method
  default_tags       = local.default_tags
  environment        = var.environment
  organization       = var.organization
}
