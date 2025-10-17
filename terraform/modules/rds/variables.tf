variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the RDS instance"
  type        = list(string)
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0.35"
}

variable "instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage in GB"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Whether to encrypt storage"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = ""
}

variable "database_name" {
  description = "Name of the database"
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "Username for the database"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Port for the database"
  type        = number
  default     = 3306
}

variable "publicly_accessible" {
  description = "Whether the database is publicly accessible"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "monitoring_interval" {
  description = "Monitoring interval in seconds"
  type        = number
  default     = 0
}

variable "performance_insights_enabled" {
  description = "Whether to enable Performance Insights"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "Performance Insights retention period in days"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Whether to enable Multi-AZ"
  type        = bool
  default     = false
}

variable "parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = "mysql8.0"
}

variable "parameters" {
  description = "List of parameters for the parameter group"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
  default     = "db01"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "organization" {
  description = "Organization name"
  type        = string
  default     = "bashlinux"
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}
