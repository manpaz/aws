variable "domain_name" {
  description = "Domain name for the hosted zone"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC for private hosted zone"
  type        = string
  default     = ""
}

variable "create_public_zone" {
  description = "Whether to create a public hosted zone"
  type        = bool
  default     = true
}

variable "create_private_zone" {
  description = "Whether to create a private hosted zone"
  type        = bool
  default     = false
}

variable "dns_records" {
  description = "Map of DNS records to create"
  type = map(object({
    name  = string
    type  = string
    ttl   = number
    records = list(string)
    alias = object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    })
  }))
  default = {}
}

variable "health_checks" {
  description = "Map of health checks to create"
  type = map(object({
    fqdn                            = string
    port                            = number
    type                            = string
    resource_path                   = string
    failure_threshold               = number
    request_interval                = number
    cloudwatch_alarm_name           = string
    cloudwatch_alarm_region         = string
    insufficient_data_health_status = string
  }))
  default = {}
}

variable "resolver_rules" {
  description = "Map of Route53 resolver rules"
  type = map(object({
    domain_name          = string
    name                 = string
    rule_type            = string
    resolver_endpoint_id = string
    target_ips = list(object({
      ip   = string
      port = number
    }))
  }))
  default = {}
}

variable "resolver_rule_associations" {
  description = "Map of resolver rule associations"
  type = map(object({
    resolver_rule_id = string
    vpc_id          = string
  }))
  default = {}
}

variable "create_certificate" {
  description = "Whether to create an ACM certificate"
  type        = bool
  default     = false
}

variable "certificate_domain" {
  description = "Domain name for the certificate"
  type        = string
  default     = ""
}

variable "certificate_san_domains" {
  description = "Subject alternative names for the certificate"
  type        = list(string)
  default     = []
}

variable "certificate_validation_method" {
  description = "Validation method for the certificate"
  type        = string
  default     = "DNS"
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
