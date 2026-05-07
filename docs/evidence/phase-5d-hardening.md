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

Phase 5D Terraform changes were applied after plan review.

ALB access logging is optional and disabled by default. Enabling it creates an S3 bucket and adds storage cost based on log volume and retention.

## Phase 5D Apply Evidence

- Terraform apply completed successfully
- CloudWatch alarms created
- ALB access logging support configured
- Migration workflow added as manual GitHub Actions workflow
- GitHub Actions IAM role policy updated for one-off ECS migration tasks
- ECS services remained healthy after hardening
- Web target group remained healthy on port 3000
- API target group remained healthy on port 4000
- API `/health` endpoint remained healthy

## Applied CloudWatch Alarms

- securebank-dev-alb-5xx-errors
- securebank-dev-api-unhealthy-targets
- securebank-dev-web-unhealthy-targets
- securebank-dev-api-ecs-cpu-high
- securebank-dev-web-ecs-cpu-high
- securebank-dev-api-ecs-memory-high
- securebank-dev-web-ecs-memory-high
- securebank-dev-rds-cpu-high
- securebank-dev-rds-free-storage-low

## Post-Apply Health Check

```json
{"status":"ok","service":"securebank-api","database":"connected"}
```
