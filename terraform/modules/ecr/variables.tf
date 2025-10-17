variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Whether to scan images on push"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type for the repository"
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = ""
}

variable "max_image_count" {
  description = "Maximum number of images to keep"
  type        = number
  default     = 10
}

variable "untagged_image_expiry_days" {
  description = "Number of days to keep untagged images"
  type        = number
  default     = 7
}

variable "allowed_principals" {
  description = "List of AWS principals allowed to push/pull"
  type        = list(string)
  default     = ["*"]
}

variable "create_iam_role" {
  description = "Whether to create IAM role for CI/CD"
  type        = bool
  default     = false
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
