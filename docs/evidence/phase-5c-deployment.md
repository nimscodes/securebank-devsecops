# Phase 5C Deployment Evidence

## Deployment Status

- ECS cluster: securebank-dev-cluster
- Web service: running 1/1, rollout completed
- API service: running 1/1, rollout completed
- Web target group: healthy on port 3000
- API target group: healthy on port 4000
- ALB web response: HTTP 200
- API health endpoint: /health returned database connected
- RDS public access: false
- RDS storage encryption: true
- CloudWatch logs: web and API logs available

## Validation

Terraform plan result after deployment:

```text
No changes
```

## Notes

This confirms the dev environment is deployed and matches the Terraform configuration.

## Redeployment Check

The dev stack was redeployed again on May 13, 2026 after a cost-control teardown.

Validation after redeploy:

- Terraform plan: no changes
- ECS web service: running 1/1
- ECS API service: running 1/1
- Web target group: healthy on port 3000
- API target group: healthy on port 4000
- ALB web route: HTTP 200
- API `/health`: HTTP 200 with database connected
- WAF Web ACL: attached to the ALB

One issue came up during redeploy: the placeholder Secrets Manager entries were still in the deletion recovery window from the teardown. They were restored and imported back into Terraform state, then Terraform returned to a clean no-change plan.
