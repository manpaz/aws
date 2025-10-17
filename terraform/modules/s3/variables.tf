variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "public_access" {
  description = "Whether the bucket allows public access"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Whether to enable versioning"
  type        = bool
  default     = true
}

variable "encryption_algorithm" {
  description = "Server-side encryption algorithm"
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = ""
}

variable "bucket_key_enabled" {
  description = "Whether to enable bucket key"
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "Whether to block public ACLs"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether to block public policies"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether to ignore public ACLs"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether to restrict public buckets"
  type        = bool
  default     = true
}

variable "bucket_policy" {
  description = "Bucket policy JSON"
  type        = string
  default     = ""
}

variable "cors_rules" {
  description = "List of CORS rules"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = []
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
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

variable "lambda_notifications" {
  description = "List of Lambda notifications"
  type = list(object({
    lambda_function_arn = string
    events              = list(string)
    filter_prefix       = string
    filter_suffix       = string
  }))
  default = []
}

variable "website_configuration" {
  description = "Website configuration"
  type = object({
    index_document = string
    error_document = string
  })
  default = null
}

variable "logging_target_bucket" {
  description = "Target bucket for logging"
  type        = string
  default     = ""
}

variable "logging_target_prefix" {
  description = "Target prefix for logging"
  type        = string
  default     = "logs/"
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
