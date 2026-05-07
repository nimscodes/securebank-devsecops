variable "name_prefix" {
  description = "Name prefix used for VPC endpoint resources."
  type        = string
}

variable "aws_region" {
  description = "AWS region for regional VPC endpoint service names."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where endpoints are created."
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private application subnet IDs for interface endpoints."
  type        = list(string)
}

variable "private_app_route_table_id" {
  description = "Private application route table ID for the S3 gateway endpoint."
  type        = string
}

variable "ecs_security_group_id" {
  description = "Security group ID used by ECS tasks."
  type        = string
}

variable "tags" {
  description = "Tags applied to VPC endpoint resources."
  type        = map(string)
  default     = {}
}
