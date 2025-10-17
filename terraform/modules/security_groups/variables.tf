variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
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

variable "deployer_ip" {
  description = "IP address of the deployer"
  type        = string
}

variable "deployer_name" {
  description = "Name of the deployer"
  type        = string
}

variable "sg_common_id" {
  description = "ID of the common security group"
  type        = string
  default     = ""
}
