# RDS Module

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.organization}-${var.environment}-${var.engine}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-${var.engine}-subnet-group"
  })
}

# DB Parameter Group
resource "aws_db_parameter_group" "main" {
  family = var.parameter_group_family
  name   = "${var.organization}-${var.environment}-${var.engine}-params"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = var.default_tags
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier = "${var.cluster_name}-${var.environment}"

  # Engine configuration
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  # Storage configuration
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type         = var.storage_type
  storage_encrypted    = var.storage_encrypted
  kms_key_id          = var.kms_key_id

  # Database configuration
  db_name  = var.database_name
  username = var.username
  password = var.password
  port     = var.port

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = var.publicly_accessible

  # Backup configuration
  backup_retention_period = var.backup_retention_period
  backup_window         = var.backup_window
  maintenance_window    = var.maintenance_window
  copy_tags_to_snapshot = true

  # Monitoring configuration
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? aws_iam_role.rds_enhanced_monitoring[0].arn : null

  # Performance Insights
  performance_insights_enabled = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  # Parameter group
  parameter_group_name = aws_db_parameter_group.main.name

  # Deletion protection
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.cluster_name}-${var.environment}-final-snapshot"

  # Multi-AZ
  multi_az = var.multi_az

  tags = merge(var.default_tags, {
    Name = "${var.cluster_name}-${var.environment}"
    "bashlinux:application-role" = "db"
    "bashlinux:network-visibility" = "private"
  })

  depends_on = [aws_db_subnet_group.main]
}

# Enhanced Monitoring IAM Role
resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0
  name  = "${var.organization}-${var.environment}-rds-enhanced-monitoring"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count      = var.monitoring_interval > 0 ? 1 : 0
  role       = aws_iam_role.rds_enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
