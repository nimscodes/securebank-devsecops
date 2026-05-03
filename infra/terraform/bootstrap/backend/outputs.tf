output "state_bucket_name" {
  description = "Terraform state S3 bucket name."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_arn" {
  description = "Terraform state S3 bucket ARN."
  value       = aws_s3_bucket.terraform_state.arn
}

output "lock_table_name" {
  description = "Terraform lock DynamoDB table name."
  value       = aws_dynamodb_table.terraform_locks.name
}

output "lock_table_arn" {
  description = "Terraform lock DynamoDB table ARN."
  value       = aws_dynamodb_table.terraform_locks.arn
}
