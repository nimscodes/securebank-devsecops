# Screenshot Checklist

This folder is reserved for manually added project screenshots. Do not commit secrets, account-sensitive pages, credentials, private keys, Terraform state, or `.tfvars` values.

Recommended screenshots:

- GitHub Actions CI passing
- Terraform Plan workflow passing
- ECR image repositories with web/API images
- ECS cluster services healthy
- ALB target groups healthy
- RDS instance showing private access and encryption
- CloudWatch alarms in OK state
- WAF Web ACL attached to the ALB
- API `/health` response
- Terraform plan/apply evidence with sensitive values hidden
- Repository file tree showing apps, infra, docs, and workflows

Before adding screenshots:

- Crop out AWS account IDs where practical.
- Hide ARNs if they reveal account-specific details.
- Blur emails, usernames, tokens, URLs that should not be public, and any billing information.
- Prefer evidence screenshots over screenshots that reveal configuration secrets.
