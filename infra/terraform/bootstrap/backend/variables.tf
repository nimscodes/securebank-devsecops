variable "aws_region" {
  description = "AWS region for Terraform backend bootstrap resources."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for backend resource tagging."
  type        = string
  default     = "securebank"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking."
  type        = string
}

variable "tags" {
  description = "Additional tags applied to backend resources."
  type        = map(string)
  default = {
    Owner = "platform"
  }
}
