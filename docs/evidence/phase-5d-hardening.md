# Phase 5D Hardening Evidence

## Scope

Phase 5D adds operational readiness for the deployed SecureBank dev environment.

## Added Controls

- Manual Prisma migration workflow design using one-off ECS tasks
- CloudWatch alarms for ALB, ECS, target health, and RDS metrics
- Optional ALB access logging support with S3 retention controls
- Runbooks for rollback, API health check failures, database connection failures, and migrations

## CloudWatch Alarms Planned

- ALB 5xx errors
- Web target unhealthy count
- API target unhealthy count
- Web ECS CPU utilization
- API ECS CPU utilization
- Web ECS memory utilization
- API ECS memory utilization
- RDS CPU utilization
- RDS free storage space

## Validation

Phase 5D is complete only after:

```bash
terraform fmt -recursive infra/terraform
cd infra/terraform/environments/dev
terraform validate
terraform plan
```

## Notes

No Phase 5D Terraform changes should be applied until the plan is reviewed.

ALB access logging is optional and disabled by default. Enabling it creates an S3 bucket and adds storage cost based on log volume and retention.
