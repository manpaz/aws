# S3 Module

# S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-${var.bucket_name}"
    "bashlinux:application-role" = "storage"
    "bashlinux:network-visibility" = var.public_access ? "public" : "private"
  })
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# S3 Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.encryption_algorithm
      kms_master_key_id = var.kms_key_id != "" ? var.kms_key_id : null
    }
    bucket_key_enabled = var.bucket_key_enabled
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "main" {
  count  = var.bucket_policy != "" ? 1 : 0
  bucket = aws_s3_bucket.main.id
  policy = var.bucket_policy
}

# S3 Bucket CORS Configuration
resource "aws_s3_bucket_cors_configuration" "main" {
  count  = length(var.cors_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.main.id

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

# S3 Bucket Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.main.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "expiration" {
        for_each = rule.value.expiration != null ? [rule.value.expiration] : []
        content {
          days = expiration.value.days
        }
      }

      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration != null ? [rule.value.noncurrent_version_expiration] : []
        content {
          noncurrent_days = noncurrent_version_expiration.value.noncurrent_days
        }
      }
    }
  }
}

# S3 Bucket Notification
resource "aws_s3_bucket_notification" "main" {
  count  = length(var.lambda_notifications) > 0 ? 1 : 0
  bucket = aws_s3_bucket.main.id

  dynamic "lambda_function" {
    for_each = var.lambda_notifications
    content {
      lambda_function_arn = lambda_function.value.lambda_function_arn
      events              = lambda_function.value.events
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
    }
  }
}

# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "main" {
  count  = var.website_configuration != null ? 1 : 0
  bucket = aws_s3_bucket.main.id

  index_document {
    suffix = var.website_configuration.index_document
  }

  error_document {
    key = var.website_configuration.error_document
  }
}

# S3 Bucket Logging
resource "aws_s3_bucket_logging" "main" {
  count  = var.logging_target_bucket != "" ? 1 : 0
  bucket = aws_s3_bucket.main.id

  target_bucket = var.logging_target_bucket
  target_prefix = var.logging_target_prefix
}
