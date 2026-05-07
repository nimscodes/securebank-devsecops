locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix              = local.name_prefix
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  enable_nat_gateway       = var.enable_nat_gateway
  tags                     = local.common_tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  name_prefix          = local.name_prefix
  vpc_id               = module.vpc.vpc_id
  alb_ingress_cidr     = var.alb_ingress_cidr
  enable_https_ingress = var.certificate_arn != null && var.certificate_arn != ""
  web_container_port   = var.web_container_port
  api_container_port   = var.api_container_port
  database_port        = var.database_port
  tags                 = local.common_tags
}

module "vpc_endpoints" {
  count  = var.enable_private_service_endpoints ? 1 : 0
  source = "../../modules/vpc-endpoints"

  name_prefix                = local.name_prefix
  aws_region                 = var.aws_region
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_ids     = module.vpc.private_app_subnet_ids
  private_app_route_table_id = module.vpc.private_app_route_table_id
  ecs_security_group_id      = module.security_groups.ecs_security_group_id
  tags                       = local.common_tags
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  web_log_group_name = "/securebank/${var.environment}/web"
  api_log_group_name = "/securebank/${var.environment}/api"
  name_prefix        = local.name_prefix
  retention_in_days  = var.log_retention_in_days
  enable_alarms      = var.enable_cloudwatch_alarms
  alarm_actions      = var.alarm_actions
  alb_arn_suffix     = module.alb.alb_arn_suffix
  target_groups = {
    web = module.alb.web_target_group_arn_suffix
    api = module.alb.api_target_group_arn_suffix
  }
  ecs_cluster_name = "${local.name_prefix}-cluster"
  ecs_services = {
    web = "${local.name_prefix}-web"
    api = "${local.name_prefix}-api"
  }
  rds_instance_identifier          = "${local.name_prefix}-postgres"
  alb_5xx_threshold                = var.alb_5xx_threshold
  unhealthy_target_threshold       = var.unhealthy_target_threshold
  ecs_cpu_threshold                = var.ecs_cpu_threshold
  ecs_memory_threshold             = var.ecs_memory_threshold
  rds_cpu_threshold                = var.rds_cpu_threshold
  rds_free_storage_threshold_bytes = var.rds_free_storage_threshold_bytes
  tags                             = local.common_tags
}

module "secrets_manager" {
  source = "../../modules/secrets-manager"

  name_prefix             = local.name_prefix
  recovery_window_in_days = var.secret_recovery_window_in_days
  tags                    = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  name_prefix             = local.name_prefix
  private_db_subnet_ids   = module.vpc.private_db_subnet_ids
  security_group_ids      = [module.security_groups.rds_security_group_id]
  database_name           = var.database_name
  master_username         = var.database_master_username
  database_port           = var.database_port
  engine_version          = var.database_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_max_allocated_storage
  backup_retention_period = var.db_backup_retention_period
  multi_az                = var.db_multi_az
  deletion_protection     = var.db_deletion_protection
  skip_final_snapshot     = var.db_skip_final_snapshot
  tags                    = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  name_prefix                = local.name_prefix
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  alb_security_group_id      = module.security_groups.alb_security_group_id
  web_container_port         = var.web_container_port
  api_container_port         = var.api_container_port
  web_health_check_path      = var.web_health_check_path
  api_health_check_path      = var.api_health_check_path
  certificate_arn            = var.certificate_arn
  enable_deletion_protection = var.alb_deletion_protection
  enable_access_logs         = var.enable_alb_access_logs
  access_logs_bucket_name    = var.alb_access_logs_bucket_name
  access_logs_prefix         = var.alb_access_logs_prefix
  access_logs_retention_days = var.alb_access_logs_retention_days
  tags                       = local.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  depends_on = [module.vpc_endpoints]

  name_prefix            = local.name_prefix
  aws_region             = var.aws_region
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  ecs_security_group_id  = module.security_groups.ecs_security_group_id
  web_target_group_arn   = module.alb.web_target_group_arn
  api_target_group_arn   = module.alb.api_target_group_arn
  web_image              = var.web_image
  api_image              = var.api_image
  web_container_port     = var.web_container_port
  api_container_port     = var.api_container_port
  web_cpu                = var.web_cpu
  web_memory             = var.web_memory
  api_cpu                = var.api_cpu
  api_memory             = var.api_memory
  web_desired_count      = var.web_desired_count
  api_desired_count      = var.api_desired_count
  web_log_group_name     = module.cloudwatch.web_log_group_name
  api_log_group_name     = module.cloudwatch.api_log_group_name
  web_environment        = var.web_environment
  api_environment = concat(var.api_environment, [
    {
      name  = "DB_HOST"
      value = module.rds.db_address
    },
    {
      name  = "DB_PORT"
      value = tostring(module.rds.db_port)
    },
    {
      name  = "DB_NAME"
      value = var.database_name
    },
    {
      name  = "DB_USER"
      value = var.database_master_username
    }
  ])
  web_secrets = var.web_secrets
  api_secrets = concat(var.api_secrets, [
    {
      name      = "DB_PASSWORD"
      valueFrom = "${module.rds.master_user_secret_arn}:password::"
    }
  ])
  enable_container_insights = var.enable_container_insights
  tags                      = local.common_tags
}
