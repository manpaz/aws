# ElastiCache Module

# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.organization}-${var.environment}-elasticache-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-elasticache-subnet-group"
  })
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "main" {
  family = var.parameter_group_family
  name   = "${var.organization}-${var.environment}-elasticache-params"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = var.default_tags
}

# ElastiCache Replication Group (Redis Cluster)
resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = "${var.cluster_name}-${var.environment}"
  description                = "Redis cluster for ${var.organization} ${var.environment}"
  
  # Engine configuration
  engine                     = "redis"
  engine_version            = var.engine_version
  port                      = var.port
  
  # Node configuration
  node_type                 = var.node_type
  num_cache_clusters        = var.num_cache_clusters
  num_cache_nodes          = var.num_cache_nodes
  
  # Network configuration
  subnet_group_name         = aws_elasticache_subnet_group.main.name
  security_group_ids        = var.security_group_ids
  
  # Parameter group
  parameter_group_name      = aws_elasticache_parameter_group.main.name
  
  # Backup configuration
  snapshot_retention_limit  = var.snapshot_retention_limit
  snapshot_window          = var.snapshot_window
  
  # Maintenance configuration
  maintenance_window        = var.maintenance_window
  
  # Encryption
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  kms_key_id               = var.kms_key_id
  
  # Auth
  auth_token                = var.auth_token
  
  # Multi-AZ
  multi_az_enabled          = var.multi_az_enabled
  
  # Automatic failover
  automatic_failover_enabled = var.automatic_failover_enabled
  
  # Log delivery
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.elasticache.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

  tags = merge(var.default_tags, {
    Name = "${var.cluster_name}-${var.environment}"
    "bashlinux:application-role" = "cache"
    "bashlinux:network-visibility" = "private"
  })
}

# CloudWatch Log Group for ElastiCache
resource "aws_cloudwatch_log_group" "elasticache" {
  name              = "/aws/elasticache/${var.organization}-${var.environment}-redis"
  retention_in_days = 14

  tags = var.default_tags
}

# ElastiCache Cluster (if not using replication group)
resource "aws_elasticache_cluster" "main" {
  count           = var.use_cluster ? 1 : 0
  cluster_id      = "${var.cluster_name}-${var.environment}-cluster"
  engine          = "redis"
  engine_version  = var.engine_version
  node_type       = var.node_type
  num_cache_nodes = var.num_cache_nodes
  port            = var.port
  parameter_group_name = aws_elasticache_parameter_group.main.name
  subnet_group_name   = aws_elasticache_subnet_group.main.name
  security_group_ids  = var.security_group_ids

  tags = merge(var.default_tags, {
    Name = "${var.cluster_name}-${var.environment}-cluster"
    "bashlinux:application-role" = "cache"
    "bashlinux:network-visibility" = "private"
  })
}
