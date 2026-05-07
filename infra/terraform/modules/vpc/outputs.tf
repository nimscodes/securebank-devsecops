output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = values(aws_subnet.public)[*].id
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs."
  value       = values(aws_subnet.private_app)[*].id
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs."
  value       = values(aws_subnet.private_db)[*].id
}

output "private_app_route_table_id" {
  description = "Private application route table ID."
  value       = aws_route_table.private_app.id
}
