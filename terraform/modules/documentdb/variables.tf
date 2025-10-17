variable "subnet_ids" {
  description = "List of subnet IDs for the DocumentDB cluster"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the DocumentDB cluster"
  type        = list(string)
}

variable "engine_version" {
  description = "DocumentDB engine version"
  type        = string
  default     = "4.0.0"
}

variable "instance_class" {
  description = "Instance class for DocumentDB instances"
  type        = string
  default     = "db.t4g.medium"
}

variable "instance_count" {
  description = "Number of DocumentDB instances"
  type        = number
  default     = 1
}

variable "username" {
  description = "Username for the DocumentDB cluster"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Password for the DocumentDB cluster"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Port for the DocumentDB cluster"
  type        = number
  default     = 27017
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

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = true
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

variable "parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = "docdb4.0"
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
  default     = "documentdb"
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
