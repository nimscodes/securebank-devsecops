# Phase 5C Dev Deployment Preparation

Phase 5C prepares the existing Terraform dev environment for the first controlled AWS application infrastructure deployment.

Do not run `terraform apply` until the plan is reviewed and an apply is explicitly approved.

## What Terraform Will Create

The dev environment is designed to create:

- VPC
- public subnets
- private app subnets
- private database subnets
- internet gateway
- route tables
- private AWS service VPC endpoints for ECR, CloudWatch Logs, Secrets Manager, and S3
- ALB on HTTP port 80
- ALB target groups for web and API
- ECS cluster
- ECS Fargate services for web and API
- ECS task execution and task IAM roles
- RDS PostgreSQL
- AWS-managed RDS master password
- Secrets Manager placeholder secret containers
- CloudWatch log groups
- security groups

This phase does not add HTTPS, ACM, ECS deployment automation, production sizing, static AWS credentials, or real application secrets.

## Cost Warnings

This environment can create billable resources.

Pay special attention to:

- RDS PostgreSQL instance
- ALB hourly usage
- ECS Fargate running tasks
- VPC interface endpoints
- CloudWatch Logs storage
- NAT Gateway if manually enabled later

NAT Gateway remains disabled by default:

```hcl
enable_nat_gateway = false
```

Private VPC endpoints are enabled by default so ECS tasks can pull ECR images, read secrets, and write logs without NAT.

## Pre-Apply Checklist

Before applying, confirm:

- Phase 5A ECR repositories exist.
- Phase 5B pushed `latest` images for web and API.
- AWS CLI points at the intended account.
- `terraform.tfvars` is local only and not committed.
- No static AWS credentials are committed.
- `enable_nat_gateway = false`.
- `certificate_arn = null`.
- `db_deletion_protection = false` for dev teardown.
- `db_backup_retention_period = 1` for dev cost control.
- `web_desired_count = 1`.
- `api_desired_count = 1`.

Check identity:

```bash
aws sts get-caller-identity
```

## Local Variables

Create a local-only file:

```bash
cd infra/terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
```

Do not commit:

```text
terraform.tfvars
.terraform/
*.tfstate
*.tfplan
```

## Plan Command

Run from:

```text
infra/terraform/environments/dev
```

Commands:

```bash
terraform init
terraform validate
terraform plan -out=dev-app-infra.tfplan
terraform show dev-app-infra.tfplan
```

Review the plan carefully before applying.

## Manual Apply Command

Only run this after explicit approval:

```bash
terraform apply dev-app-infra.tfplan
```

## Smoke Tests After Deployment

After an approved apply, capture the ALB DNS name:

```bash
terraform output alb_dns_name
```

Test the web service:

```bash
curl http://<alb-dns-name>/
```

Test the API service:

```bash
curl http://<alb-dns-name>/health
```

Expected API health response:

```json
{
  "status": "ok",
  "service": "securebank-api"
}
```

Also verify in AWS:

- ECS services are stable.
- Target groups show healthy targets.
- CloudWatch logs receive web and API logs.
- RDS is not publicly accessible.

## Rollback and Destroy

For a dev teardown, run only after explicit approval:

```bash
terraform destroy
```

Notes:

- Dev RDS deletion protection is disabled by default for teardown.
- Final DB snapshot is skipped by default in dev.
- ECR repositories and GitHub OIDC from Phase 5A are owned by `infra/terraform/bootstrap/oidc-ecr`, not by the dev environment.
- Terraform backend resources are owned by `infra/terraform/bootstrap/backend`.

## Troubleshooting ECS Health Checks

If web targets are unhealthy:

- Confirm the web container listens on port `3000`.
- Confirm the web target group health path is `/`.
- Check `/securebank/dev/web` logs in CloudWatch.

If API targets are unhealthy:

- Confirm the API container listens on port `4000`.
- Confirm the API target group health path is `/health`.
- Check `/securebank/dev/api` logs in CloudWatch.
- Confirm `DB_HOST`, `DB_PORT`, `DB_NAME`, and `DB_USER` are set in the API task definition.
- Confirm `DB_PASSWORD` is injected from the AWS-managed RDS secret.
- Confirm ECS can reach Secrets Manager through the VPC endpoint.
- Confirm ECS can reach RDS on PostgreSQL port `5432`.

If image pulls fail:

- Confirm Phase 5B pushed `latest` tags to both ECR repositories.
- Confirm ECR API and ECR Docker VPC endpoints exist.
- Confirm the S3 gateway endpoint is associated with the private app route table.
- Confirm the ECS task execution role has ECR permissions.

If logs do not appear:

- Confirm the CloudWatch Logs VPC endpoint exists.
- Confirm the ECS task execution role has log permissions.
- Confirm log groups exist.

## Security Notes

Traffic flow is intentionally restricted:

```text
internet -> ALB port 80
ALB -> ECS web port 3000
ALB -> ECS API port 4000
ECS -> RDS PostgreSQL port 5432
```

RDS remains private:

```text
publicly_accessible = false
storage_encrypted   = true
```

No real secrets are hardcoded in Terraform or application code.
