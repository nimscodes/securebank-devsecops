# API Health Check Failure Runbook

## Symptoms

- ALB returns `503` for `/health`
- API target group shows unhealthy or draining targets
- ECS API service repeatedly starts and stops tasks

## Checks

Check the API target group:

```bash
aws elbv2 describe-target-health \
  --region us-east-1 \
  --target-group-arn <api-target-group-arn>
```

Check ECS service events:

```bash
aws ecs describe-services \
  --region us-east-1 \
  --cluster securebank-dev-cluster \
  --services securebank-dev-api \
  --query 'services[0].events[0:10]'
```

Check recent API logs:

```bash
aws logs describe-log-streams \
  --region us-east-1 \
  --log-group-name /securebank/dev/api \
  --order-by LastEventTime \
  --descending \
  --max-items 3
```

```bash
aws logs get-log-events \
  --region us-east-1 \
  --log-group-name /securebank/dev/api \
  --log-stream-name <latest-log-stream>
```

## Common Causes

- API container cannot connect to RDS
- `DATABASE_URL` is malformed
- RDS password was not URL-encoded before building `DATABASE_URL`
- ECS task cannot read Secrets Manager secret
- API image tag points to an old or broken image
- Security group no longer allows ALB to reach port `4000`

## Expected Healthy Response

```bash
curl http://securebank-dev-alb-1307172930.us-east-1.elb.amazonaws.com/health
```

Expected:

```json
{"status":"ok","service":"securebank-api","database":"connected"}
```

## Fix Path

1. Read CloudWatch logs first.
2. Confirm ECS task execution role can read the RDS managed password secret.
3. Confirm `DB_HOST`, `DB_PORT`, `DB_NAME`, and `DB_USER` are injected into the API task.
4. Confirm the ECS startup command URL-encodes `DB_PASSWORD`.
5. Roll back to the previous API task definition if the latest image is broken.
