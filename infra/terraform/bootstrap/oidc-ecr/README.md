# OIDC and ECR Bootstrap

This bootstrap environment creates only the AWS resources needed before CI can safely authenticate and prepare container images:

- GitHub OIDC provider
- GitHub Actions IAM role restricted to `nimscodes/securebank-devsecops`
- ECR repository for the web image
- ECR repository for the API image

It does not create VPCs, subnets, NAT gateways, ALBs, ECS services, RDS databases, security groups, CloudWatch app logs, or Secrets Manager app secrets.

## Why This Is Separate

ECR and GitHub OIDC are bootstrap resources. They should be created before the dev app infrastructure so GitHub Actions can run safe Terraform plans and later push images without long-lived AWS keys.

Keeping this in `infra/terraform/bootstrap/oidc-ecr` avoids targeted applies from `infra/terraform/environments/dev`.

## Local Setup

Copy the example variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Replace these placeholder values before any approved apply:

```text
aws_account_id
terraform_state_bucket_name
terraform_lock_table_name
```

Do not commit `terraform.tfvars`.

## Validate and Plan

Run from this folder:

```bash
terraform init -backend=false
terraform validate
terraform plan -out=oidc-ecr-bootstrap.tfplan
terraform show oidc-ecr-bootstrap.tfplan
```

Before applying, confirm the plan includes only ECR and IAM/OIDC resources, such as:

```text
aws_ecr_repository
aws_ecr_lifecycle_policy
aws_iam_openid_connect_provider
aws_iam_role
aws_iam_policy
aws_iam_role_policy_attachment
```

The plan must not include:

```text
aws_vpc
aws_subnet
aws_nat_gateway
aws_lb
aws_ecs_service
aws_db_instance
aws_security_group
aws_cloudwatch_log_group
aws_secretsmanager_secret
```

## Approved Apply Command

Only run this after the plan is reviewed and Phase 5A apply is explicitly approved:

```bash
terraform apply oidc-ecr-bootstrap.tfplan
```

## Outputs

After an approved apply, capture:

```bash
terraform output github_actions_role_arn
terraform output web_ecr_repository_url
terraform output api_ecr_repository_url
```

Use `github_actions_role_arn` as the GitHub repository variable `AWS_ROLE_ARN`.

## Do Not Commit

Never commit:

- `terraform.tfvars`
- `.terraform/`
- `.terraform.lock.hcl` changes you do not intend to keep
- `*.tfstate`
- `*.tfplan`
- AWS credentials
- real secrets
