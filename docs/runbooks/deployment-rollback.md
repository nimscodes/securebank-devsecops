# Deployment Rollback Runbook

## Purpose

Use this runbook when a new SecureBank container image or ECS task definition causes failed health checks, bad responses, or unstable service behavior.

## Quick Checks

```bash
aws ecs describe-services \
  --region us-east-1 \
  --cluster securebank-dev-cluster \
  --services securebank-dev-web securebank-dev-api
```

```bash
curl http://securebank-dev-alb-1307172930.us-east-1.elb.amazonaws.com
curl http://securebank-dev-alb-1307172930.us-east-1.elb.amazonaws.com/health
```

## Roll Back an ECS Service

List task definition revisions:

```bash
aws ecs list-task-definitions \
  --region us-east-1 \
  --family-prefix securebank-dev-api \
  --sort DESC
```

Update the service to the last known-good task definition:

```bash
aws ecs update-service \
  --region us-east-1 \
  --cluster securebank-dev-cluster \
  --service securebank-dev-api \
  --task-definition <previous-task-definition-arn>
```

Wait for stability:

```bash
aws ecs wait services-stable \
  --region us-east-1 \
  --cluster securebank-dev-cluster \
  --services securebank-dev-api
```

Repeat the same process for `securebank-dev-web` if the web service is affected.

## Terraform Note

If rollback is done manually through ECS, Terraform may later show drift. After the emergency is stable, update Terraform variables or redeploy the correct image so Terraform and AWS match again.

## Do Not

- Do not destroy the dev environment to roll back an app image.
- Do not open RDS to the public internet.
- Do not run destructive database migration commands.
- Do not commit emergency local `terraform.tfvars`, `.tfplan`, or state files.
