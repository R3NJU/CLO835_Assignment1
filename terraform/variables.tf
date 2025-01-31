# Provision public subnets in custom VPC
variable "public_cidr_block" {
  default     = "10.1.1.0/24"
  type        = string
  description = "Public Subnet CIDR"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "Main VPC"
}