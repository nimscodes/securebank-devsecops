variable "name_prefix" {
  description = "Name prefix used for security groups."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups are created."
  type        = string
}

variable "alb_ingress_cidr" {
  description = "CIDR block allowed to reach the ALB."
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_https_ingress" {
  description = "Whether to allow internet HTTPS traffic to the ALB security group."
  type        = bool
  default     = false
}

variable "web_container_port" {
  description = "Web container port."
  type        = number
}

variable "api_container_port" {
  description = "API container port."
  type        = number
}

variable "database_port" {
  description = "PostgreSQL database port."
  type        = number
  default     = 5432
}

variable "tags" {
  description = "Tags applied to security groups."
  type        = map(string)
  default     = {}
}
