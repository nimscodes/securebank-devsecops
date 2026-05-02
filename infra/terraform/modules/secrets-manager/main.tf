resource "aws_secretsmanager_secret" "app_config" {
  name                    = "${var.name_prefix}/app/config"
  description             = "Placeholder for SecureBank application configuration secrets."
  recovery_window_in_days = var.recovery_window_in_days

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-config"
  })
}

resource "aws_secretsmanager_secret" "database_config" {
  name                    = "${var.name_prefix}/database/config"
  description             = "Placeholder for SecureBank database configuration secrets."
  recovery_window_in_days = var.recovery_window_in_days

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-database-config"
  })
}
