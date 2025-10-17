# DocumentDB Module

# DocumentDB Subnet Group
resource "aws_docdb_subnet_group" "main" {
  name       = "${var.organization}-${var.environment}-documentdb-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-documentdb-subnet-group"
  })
}

# DocumentDB Parameter Group
resource "aws_docdb_cluster_parameter_group" "main" {
  family = var.parameter_group_family
  name   = "${var.organization}-${var.environment}-documentdb-params"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = var.default_tags
}

# DocumentDB Cluster
resource "aws_docdb_cluster" "main" {
  cluster_identifier      = "${var.cluster_name}-${var.environment}"
  engine                 = "docdb"
  engine_version         = var.engine_version
  master_username        = var.username
  master_password        = var.password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.backup_window
  skip_final_snapshot    = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  storage_encrypted      = var.storage_encrypted
  kms_key_id            = var.kms_key_id
  port                  = var.port
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_docdb_subnet_group.main.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name

  tags = merge(var.default_tags, {
    Name = "${var.cluster_name}-${var.environment}"
    "bashlinux:application-role" = "documentdb"
    "bashlinux:network-visibility" = "private"
  })
}

# DocumentDB Cluster Instances
resource "aws_docdb_cluster_instance" "main" {
  count              = var.instance_count
  identifier         = "${var.cluster_name}-${var.environment}-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = var.instance_class
  engine             = aws_docdb_cluster.main.engine

  tags = merge(var.default_tags, {
    Name = "${var.cluster_name}-${var.environment}-${count.index + 1}"
  })
}
