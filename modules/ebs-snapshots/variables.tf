variable "instance_id" {
  description = "Instance ID for attaching the EIP"
}

variable "availability_zone" {
  description = "Availability zone where resources will be created"
}

variable "backup_role_arn" {
  default = "arn:aws:iam::545009864075:role/AWSBackup"
}
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "ap-south-1"
}

