# IAM Role
variable "iam_role" {
  default     = "LabInstanceProfile"
  type        = string
  description = "IAM Role for EC2"
}

# Instance Type
variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "Instance type for EC2"
}