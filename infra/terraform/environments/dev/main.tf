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

  name_prefix        = local.name_prefix
  vpc_id             = module.vpc.vpc_id
  alb_ingress_cidr   = var.alb_ingress_cidr
  web_container_port = var.web_container_port
  api_container_port = var.api_container_port
  database_port      = var.database_port
  tags               = local.common_tags
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  web_log_group_name = "/securebank/${var.environment}/web"
  api_log_group_name = "/securebank/${var.environment}/api"
  retention_in_days  = var.log_retention_in_days
  tags               = local.common_tags
}

module "secrets_manager" {
  source = "../../modules/secrets-manager"

  name_prefix             = local.name_prefix
  recovery_window_in_days = var.secret_recovery_window_in_days
  tags                    = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  web_repository_name            = "${local.name_prefix}-web"
  api_repository_name            = "${local.name_prefix}-api"
  image_tag_mutability           = var.ecr_image_tag_mutability
  max_tagged_images              = var.ecr_max_tagged_images
  untagged_image_expiration_days = var.ecr_untagged_image_expiration_days
  tags                           = local.common_tags
}

module "github_oidc" {
  source = "../../modules/github-oidc"

  name_prefix                 = local.name_prefix
  aws_region                  = var.aws_region
  aws_account_id              = var.aws_account_id
  github_repository           = var.github_repository
  github_branch               = var.github_branch
  ecr_repository_arns         = module.ecr.repository_arns
  terraform_state_bucket_name = var.terraform_state_bucket_name
  terraform_lock_table_name   = var.terraform_lock_table_name
  terraform_state_key_prefix  = var.terraform_state_key_prefix
  tags                        = local.common_tags
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
  instance_class          = var.database_instance_class
  allocated_storage       = var.database_allocated_storage
  max_allocated_storage   = var.database_max_allocated_storage
  backup_retention_period = var.database_backup_retention_period
  deletion_protection     = var.database_deletion_protection
  skip_final_snapshot     = var.database_skip_final_snapshot
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
  tags                       = local.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  name_prefix               = local.name_prefix
  aws_region                = var.aws_region
  private_app_subnet_ids    = module.vpc.private_app_subnet_ids
  ecs_security_group_id     = module.security_groups.ecs_security_group_id
  web_target_group_arn      = module.alb.web_target_group_arn
  api_target_group_arn      = module.alb.api_target_group_arn
  web_image                 = var.web_image
  api_image                 = var.api_image
  web_container_port        = var.web_container_port
  api_container_port        = var.api_container_port
  web_cpu                   = var.web_cpu
  web_memory                = var.web_memory
  api_cpu                   = var.api_cpu
  api_memory                = var.api_memory
  web_desired_count         = var.web_desired_count
  api_desired_count         = var.api_desired_count
  web_log_group_name        = module.cloudwatch.web_log_group_name
  api_log_group_name        = module.cloudwatch.api_log_group_name
  web_environment           = var.web_environment
  api_environment           = var.api_environment
  web_secrets               = var.web_secrets
  api_secrets               = var.api_secrets
  enable_container_insights = var.enable_container_insights
  tags                      = local.common_tags
}
