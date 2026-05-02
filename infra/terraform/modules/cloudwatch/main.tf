resource "aws_cloudwatch_log_group" "web" {
  name              = var.web_log_group_name
  retention_in_days = var.retention_in_days

  tags = merge(var.tags, {
    Name = var.web_log_group_name
  })
}

resource "aws_cloudwatch_log_group" "api" {
  name              = var.api_log_group_name
  retention_in_days = var.retention_in_days

  tags = merge(var.tags, {
    Name = var.api_log_group_name
  })
}
