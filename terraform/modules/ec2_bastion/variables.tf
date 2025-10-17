variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for the bastion host"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t3.small"
}

variable "ebs_volume_size" {
  description = "Size of the EBS volume in GB"
  type        = number
  default     = 20
}

variable "public_key" {
  description = "Public key for SSH access"
  type        = string
}

variable "deployer_ip" {
  description = "IP address of the deployer"
  type        = string
}

variable "domain" {
  description = "Domain name for the bastion host"
  type        = string
}

variable "hosted_zone_id" {
  description = "ID of the hosted zone"
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
