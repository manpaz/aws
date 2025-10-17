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

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.11.0.0/20"
}

variable "public_subnet_1a_cidr" {
  description = "CIDR block for public subnet 1a"
  type        = string
  default     = "10.11.0.0/26"
}

variable "public_subnet_1b_cidr" {
  description = "CIDR block for public subnet 1b"
  type        = string
  default     = "10.11.0.64/26"
}

variable "public_subnet_2a_cidr" {
  description = "CIDR block for public subnet 2a"
  type        = string
  default     = "10.11.1.0/26"
}

variable "public_subnet_2b_cidr" {
  description = "CIDR block for public subnet 2b"
  type        = string
  default     = "10.11.1.64/26"
}

variable "private_subnet_1a_cidr" {
  description = "CIDR block for private subnet 1a"
  type        = string
  default     = "10.11.2.0/24"
}

variable "private_subnet_1b_cidr" {
  description = "CIDR block for private subnet 1b"
  type        = string
  default     = "10.11.3.0/24"
}

variable "private_subnet_2a_cidr" {
  description = "CIDR block for private subnet 2a"
  type        = string
  default     = "10.11.5.0/24"
}

variable "private_subnet_2b_cidr" {
  description = "CIDR block for private subnet 2b"
  type        = string
  default     = "10.11.6.0/24"
}

variable "private_subnet_3a_cidr" {
  description = "CIDR block for private subnet 3a"
  type        = string
  default     = "10.11.8.0/24"
}

variable "private_subnet_3b_cidr" {
  description = "CIDR block for private subnet 3b"
  type        = string
  default     = "10.11.9.0/24"
}

variable "domain_name" {
  description = "Domain name for the environment"
  type        = string
  default     = "staging.bashlinux.com"
}
