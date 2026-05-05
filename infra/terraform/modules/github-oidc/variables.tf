variable "name_prefix" {
  description = "Name prefix used for GitHub OIDC IAM resources."
  type        = string
}

variable "aws_region" {
  description = "AWS region used for backend table ARN construction."
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID used for IAM policy resource ARNs."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to assume the OIDC role."
  type        = string
  default     = "nimscodes/securebank-devsecops"
}

variable "github_branch" {
  description = "Primary branch allowed to assume the OIDC role."
  type        = string
  default     = "main"
}

variable "thumbprint_list" {
  description = "GitHub Actions OIDC certificate thumbprints accepted by AWS IAM."
  type        = list(string)
  default     = ["2b18947a6a9fc7764fd8b5fb18a863b0c6dac24f"]
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs GitHub Actions may push and pull."
  type        = list(string)
}

variable "terraform_state_bucket_name" {
  description = "Terraform state bucket name for future remote backend access."
  type        = string
}

variable "terraform_lock_table_name" {
  description = "Terraform lock table name for future remote backend access."
  type        = string
}

variable "terraform_state_key_prefix" {
  description = "S3 key prefix for Terraform state files."
  type        = string
  default     = "securebank"
}

variable "tags" {
  description = "Tags applied to GitHub OIDC IAM resources."
  type        = map(string)
  default     = {}
}
