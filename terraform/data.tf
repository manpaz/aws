
data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
