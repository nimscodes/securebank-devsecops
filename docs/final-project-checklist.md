# Final Project Checklist

## Repo Readiness

- [ ] README clearly explains the project and why it matters.
- [ ] Architecture diagram renders in GitHub Markdown.
- [ ] Case study explains business, architecture, security, CI/CD, and operations decisions.
- [ ] Interview guide has a short pitch and common Q&A.
- [ ] Resume bullets are tailored for target roles.
- [ ] Runbooks exist for rollback, health check failure, database failure, and migrations.
- [ ] Evidence docs are linked from README and docs index.

## Security Checklist

- [ ] No AWS access keys are committed.
- [ ] No `.env` files are committed.
- [ ] No `terraform.tfvars` files are committed.
- [ ] No `.tfstate` files are committed.
- [ ] No `.tfplan` files are committed.
- [ ] GitHub Actions use OIDC instead of static credentials.
- [ ] RDS is private and encrypted when deployed.
- [ ] WAF is configured in count mode before block mode.
- [ ] Security scans run in CI.
- [ ] Security headers are configured at app and ALB layers.

## AWS Verification Checklist

- [ ] Backend S3 bucket has encryption, versioning, and public access blocked.
- [ ] DynamoDB lock table exists for Terraform state locking.
- [ ] GitHub OIDC provider exists.
- [ ] GitHub Actions role trust policy is scoped to the repo.
- [ ] ECR repositories exist for web and API.
- [ ] ECS services are healthy when dev is deployed.
- [ ] ALB target groups are healthy when dev is deployed.
- [ ] RDS is not publicly accessible.
- [ ] CloudWatch logs and alarms exist when dev is deployed.
- [ ] WAF Web ACL is attached when security layer is applied.

## Interview Readiness

- [ ] Can explain why ECS Fargate was selected.
- [ ] Can explain why Terraform modules were used.
- [ ] Can explain GitHub OIDC and why static AWS keys are avoided.
- [ ] Can explain private RDS and security group flow.
- [ ] Can explain CI/CD security scanning.
- [ ] Can explain rollback strategy.
- [ ] Can explain database migration safety.
- [ ] Can explain cost controls and cleanup.
- [ ] Can explain what would change for production.

## Cleanup and Cost Checklist

- [ ] Dev ECS services are stopped or destroyed when not demoing.
- [ ] RDS is stopped or destroyed when not demoing.
- [ ] ALB is destroyed when not needed.
- [ ] WAF is destroyed when not needed.
- [ ] CloudWatch logs and alarms are reviewed for retention/cost.
- [ ] ECR images are cleaned up if no longer needed.
- [ ] Bootstrap backend, OIDC, and ECR are preserved unless fully retiring the project.
