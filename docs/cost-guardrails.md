# Cost Guardrails

Phase 3 is infrastructure-as-code only. Do not run `terraform apply` until a deployment phase explicitly approves real AWS resource creation.

## Development Defaults

- NAT gateway creation defaults to `false`.
- ECS desired counts default to one task per service.
- Fargate task CPU and memory use small development defaults.
- RDS defaults to a small instance class and modest storage.
- ALB deletion protection defaults to `false` in dev to avoid lifecycle friction.

## Expensive Resource Awareness

- NAT gateways, ALBs, ECS tasks, RDS instances, and CloudWatch logs can create AWS costs if applied.
- Remote state, production sizing, autoscaling, and multi-environment deployment are intentionally deferred.

## Safe Commands

Use validation commands only:

```bash
terraform fmt -recursive infra/terraform
terraform init -backend=false
terraform validate
```

Avoid provisioning commands:

```bash
terraform apply
terraform destroy
```
