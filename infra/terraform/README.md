# SecureBank Terraform

Phase 3 introduces a production-style AWS infrastructure foundation for SecureBank. This is infrastructure-as-code only: do not run `terraform apply`, do not create AWS resources, and do not add real secrets or credentials.

## Structure

```text
infra/terraform/
  modules/
    alb/
    cloudwatch/
    ecs/
    ecr/
    github-oidc/
    rds/
    secrets-manager/
    security-groups/
    vpc/
  bootstrap/
    backend/
  environments/
    dev/
```

## Modules

- `vpc`: VPC, public subnets, private app subnets, private DB subnets, route tables, internet gateway, and optional NAT gateway.
- `security-groups`: ALB, ECS, and RDS security groups with scoped service-to-service traffic.
- `alb`: Public application load balancer, target groups, HTTP listener, and optional HTTPS listener.
- `ecs`: ECS Fargate cluster, task definitions, IAM roles, and services for web and API.
- `rds`: Private PostgreSQL RDS instance using AWS-managed master password support.
- `secrets-manager`: Secret containers only, with no real secret values.
- `cloudwatch`: ECS log groups for web and API services.
- `ecr`: Web and API image repositories with scan-on-push, encryption, immutable tags, and lifecycle cleanup.
- `github-oidc`: GitHub Actions OIDC provider and IAM role scoped to the SecureBank repository.

## Backend Bootstrap

`bootstrap/backend` contains the future S3 state bucket and DynamoDB lock table resources. It stays separate because backend resources must exist before environments can use a remote backend.

Remote backend configuration is intentionally not active in Phase 4.

## Safe Validation

From the repository root:

```bash
terraform fmt -recursive infra/terraform
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

## Phase Boundaries

This phase does not include AWS deployment, ECS image publishing, static AWS credentials, remote backend activation, or production infrastructure. Container image values are placeholders until a later deployment phase.
