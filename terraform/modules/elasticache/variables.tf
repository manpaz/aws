variable "subnet_ids" {
  description = "List of subnet IDs for the ElastiCache cluster"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ElastiCache cluster"
  type        = list(string)
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.0"
}

variable "node_type" {
  description = "Node type for ElastiCache"
  type        = string
  default     = "cache.t4g.micro"
}

variable "num_cache_clusters" {
  description = "Number of cache clusters"
  type        = number
  default     = 2
}

variable "num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 1
}

variable "port" {
  description = "Port for ElastiCache"
  type        = number
  default     = 6379
}

variable "snapshot_retention_limit" {
  description = "Snapshot retention limit"
  type        = number
  default     = 5
}

variable "snapshot_window" {
  description = "Snapshot window"
  type        = string
  default     = "03:00-05:00"
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:05:00-sun:07:00"
}

variable "at_rest_encryption_enabled" {
  description = "Whether to enable encryption at rest"
  type        = bool
  default     = true
}

variable "transit_encryption_enabled" {
  description = "Whether to enable encryption in transit"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = ""
}

variable "auth_token" {
  description = "Auth token for ElastiCache"
  type        = string
  sensitive   = true
  default     = ""
}

variable "multi_az_enabled" {
  description = "Whether to enable Multi-AZ"
  type        = bool
  default     = false
}

variable "automatic_failover_enabled" {
  description = "Whether to enable automatic failover"
  type        = bool
  default     = false
}

variable "use_cluster" {
  description = "Whether to use ElastiCache cluster instead of replication group"
  type        = bool
  default     = false
}

variable "parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = "redis7.x"
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
  default     = "redis"
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
