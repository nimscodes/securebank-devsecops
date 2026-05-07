# Database Migrations Runbook

## Purpose

SecureBank uses Prisma migrations to keep the PostgreSQL schema aligned with the API code.

In AWS dev, migrations should run as a one-off ECS task inside the private VPC. This lets the migration task reach the private RDS database without opening the database to the internet.

## Safe Migration Rule

Use:

```bash
npx prisma migrate deploy
```

Do not use these commands against the deployed dev database unless a rollback plan is approved:

```bash
npx prisma migrate reset
npx prisma db push --force-reset
DROP DATABASE
DROP SCHEMA
```

## GitHub Actions Workflow

Workflow:

```text
.github/workflows/database-migrations.yml
```

The workflow:

- Uses GitHub OIDC instead of static AWS keys
- Resolves the existing API ECS task definition
- Reuses the API service private subnet and security group settings
- Runs a one-off Fargate task
- Overrides the API command to run only `npx prisma migrate deploy`
- Requires manual confirmation: `run-migrations`

## Required GitHub Variables

Required:

```text
AWS_REGION
AWS_ROLE_ARN
```

Optional:

```text
ECS_CLUSTER_NAME = securebank-dev-cluster
API_SERVICE_NAME = securebank-dev-api
```

## IAM Notes

The GitHub OIDC role needs permission to:

- Describe ECS services and tasks
- Run the API task definition
- Pass the ECS task execution and task roles to ECS
- Read Terraform state if workflows run Terraform separately

The Terraform `github-oidc` module includes these permissions as Phase 5D preparation, but they must be reviewed and applied before the migration workflow can run successfully.

## Pre-Run Checklist

- Confirm the latest API image is already deployed or compatible with the target schema.
- Review generated Prisma migration SQL.
- Confirm RDS is available.
- Confirm ECS API service is healthy before starting.
- Confirm no destructive Prisma command is being used.
- Confirm the workflow input is exactly `run-migrations`.

## Verification

After the workflow finishes:

```bash
curl http://securebank-dev-alb-1307172930.us-east-1.elb.amazonaws.com/health
```

Expected:

```json
{"status":"ok","service":"securebank-api","database":"connected"}
```

Also check CloudWatch logs for the migration task under:

```text
/securebank/dev/api
```
