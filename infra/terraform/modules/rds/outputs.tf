output "db_instance_identifier" {
  description = "RDS instance identifier."
  value       = aws_db_instance.this.identifier
}

output "db_endpoint" {
  description = "RDS endpoint."
  value       = aws_db_instance.this.endpoint
}

output "db_port" {
  description = "RDS port."
  value       = aws_db_instance.this.port
}

output "master_user_secret_arn" {
  description = "ARN of the AWS-managed master user secret."
  value       = try(aws_db_instance.this.master_user_secret[0].secret_arn, null)
}
