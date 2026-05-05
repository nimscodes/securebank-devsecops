# Deployment Preparation

Phase 4 prepares SecureBank for future AWS deployment without deploying the app or creating resources from CI.

## Why OIDC

GitHub Actions should use OpenID Connect instead of long-lived AWS access keys.

OIDC lets GitHub request short-lived AWS credentials for a specific workflow run. That avoids storing static AWS access keys in GitHub secrets and makes the trust policy easier to scope to this repository.

The Terraform module scopes trust to:

```text
nimscodes/securebank-devsecops
```

The workflow needs:

```yaml
permissions:
  id-token: write
```

## Terraform Backend Bootstrap

Terraform remote state needs storage before environments can use it.

The backend bootstrap folder is separate:

```text
infra/terraform/bootstrap/backend
```

It defines:

- S3 bucket for Terraform state
- DynamoDB table for state locking
- bucket versioning
- server-side encryption
- public access blocking
- lifecycle protection comments and safeguards

Do not enable the dev remote backend until the bootstrap resources are manually created in a later approved phase.

## OIDC and ECR Bootstrap

GitHub OIDC and ECR are also separated from the dev app environment:

```text
infra/terraform/bootstrap/oidc-ecr
```

This environment creates only:

- GitHub OIDC provider
- GitHub Actions IAM role scoped to `nimscodes/securebank-devsecops`
- web ECR repository
- API ECR repository

It does not create VPC, subnets, NAT Gateway, ALB, ECS, RDS, security groups, CloudWatch app logs, or Secrets Manager app secrets.

This avoids targeted applies from `infra/terraform/environments/dev`.

## ECR and Deployment

The ECR module prepares repositories for:

- `securebank-dev-web`
- `securebank-dev-api`

Both repositories are configured for image scanning on push, encryption, immutable tags, and lifecycle cleanup.

The Phase 4 Docker workflow builds images only. It does not push images yet.

## Required GitHub Repository Variables

Configure these later in GitHub repository settings after the OIDC role exists:

```text
AWS_ROLE_ARN
AWS_REGION
```

No AWS access keys should be added.

## What Not To Commit

Never commit:

- AWS access keys
- static AWS credentials
- `.tfstate` files
- `.tfplan` files
- real secrets
- generated credential files
- copied backend files that contain account-specific private values

## Phase 4 Validation Commands

From the repo root:

```bash
terraform fmt -recursive infra/terraform
```

From `infra/terraform/bootstrap/backend`:

```bash
terraform init -backend=false
terraform validate
```

From `infra/terraform/bootstrap/oidc-ecr`:

```bash
terraform init -backend=false
terraform validate
terraform plan
```

From `infra/terraform/environments/dev`:

```bash
terraform init -backend=false
terraform validate
```

Do not run:

```bash
terraform apply
terraform destroy
```

## Safer Phase 5A Order

Use this order when Phase 5A apply is explicitly approved:

1. Apply `infra/terraform/bootstrap/backend`
2. Apply `infra/terraform/bootstrap/oidc-ecr`
3. Configure GitHub repository variables
4. Run the Terraform Plan workflow
5. Do not apply `infra/terraform/environments/dev` until Phase 5B
