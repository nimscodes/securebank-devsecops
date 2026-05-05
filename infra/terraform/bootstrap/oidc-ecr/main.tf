locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Bootstrap   = "oidc-ecr"
  })
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
