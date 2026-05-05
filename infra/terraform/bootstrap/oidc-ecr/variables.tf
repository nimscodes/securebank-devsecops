variable "aws_region" {
  description = "AWS region for the OIDC and ECR bootstrap resources."
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS account ID used to build least-privilege IAM policy ARNs."
  type        = string
}

variable "project_name" {
  description = "Project name used in resource naming."
  type        = string
  default     = "securebank"
}

variable "environment" {
  description = "Environment name used in bootstrap resource naming."
  type        = string
  default     = "dev"
}

variable "github_repository" {
  description = "GitHub repository allowed to assume the OIDC role."
  type        = string
  default     = "nimscodes/securebank-devsecops"
}

variable "github_branch" {
  description = "Primary GitHub branch allowed to assume the OIDC role."
  type        = string
  default     = "main"
}

variable "terraform_state_bucket_name" {
  description = "Terraform state bucket name created by the backend bootstrap."
  type        = string
}

variable "terraform_lock_table_name" {
  description = "Terraform lock table name created by the backend bootstrap."
  type        = string
}

variable "terraform_state_key_prefix" {
  description = "S3 key prefix for Terraform state files."
  type        = string
  default     = "securebank"
}

variable "ecr_image_tag_mutability" {
  description = "ECR image tag mutability setting."
  type        = string
  default     = "IMMUTABLE"
}

variable "ecr_max_tagged_images" {
  description = "Maximum tagged images retained in each ECR repository."
  type        = number
  default     = 30
}

variable "ecr_untagged_image_expiration_days" {
  description = "Days to retain untagged ECR images."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Additional tags applied to bootstrap resources."
  type        = map(string)
  default = {
    Owner = "platform"
  }
}
