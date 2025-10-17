
locals {
  default_tags = {
    "bashlinux:organization-name" = var.organization
    "bashlinux:environment-name"  = var.environment
    "bashlinux:application-id"    = var.environment
    "bashlinux:can-delete"        = "false"
  }
}
