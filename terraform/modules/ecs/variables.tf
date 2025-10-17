variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ECS service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ECS service"
  type        = list(string)
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the task in MB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
  default     = ""
}

variable "listener_arn" {
  description = "ARN of the ALB listener"
  type        = string
  default     = ""
}

variable "listener_priority" {
  description = "Priority for the listener rule"
  type        = number
  default     = 100
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = list(map(string))
  default     = []
}

variable "environment_file_arn" {
  description = "ARN of the environment file in S3"
  type        = string
  default     = ""
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
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
