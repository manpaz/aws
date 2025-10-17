variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS cluster"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "vpc_cni_version" {
  description = "Version of the VPC CNI addon"
  type        = string
  default     = "v1.14.1-eksbuild.1"
}

variable "coredns_version" {
  description = "Version of the CoreDNS addon"
  type        = string
  default     = "v1.10.1-eksbuild.1"
}

variable "kube_proxy_version" {
  description = "Version of the kube-proxy addon"
  type        = string
  default     = "v1.28.1-eksbuild.1"
}

variable "ebs_csi_driver_version" {
  description = "Version of the EBS CSI driver addon"
  type        = string
  default     = "v1.20.0-eksbuild.1"
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
