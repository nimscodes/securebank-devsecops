# Database Connection Failure Runbook

## Symptoms

- API `/health` returns database disconnected
- API task exits during startup
- Prisma logs show connection string or authentication errors
- RDS is available but the API cannot reach it

## Checks

Verify RDS is private and available:

```bash
aws rds describe-db-instances \
  --region us-east-1 \
  --db-instance-identifier securebank-dev-postgres \
  --query 'DBInstances[0].{status:DBInstanceStatus,public:PubliclyAccessible,encrypted:StorageEncrypted,endpoint:Endpoint.Address}'
```

Verify ECS service status:

```bash
aws ecs describe-services \
  --region us-east-1 \
  --cluster securebank-dev-cluster \
  --services securebank-dev-api
```

Verify API logs:

```bash
aws logs describe-log-streams \
  --region us-east-1 \
  --log-group-name /securebank/dev/api \
  --order-by LastEventTime \
  --descending \
  --max-items 3
```

## Common Causes

- RDS is still creating or modifying
- ECS security group cannot reach RDS on `5432`
- RDS security group does not allow ECS ingress
- The RDS managed password secret cannot be read by the ECS execution role
- The password contains special URL characters and was not encoded
- Prisma migration failed before the API started

## Expected Security Model

```text
Internet -> ALB -> ECS API -> private RDS PostgreSQL
```

RDS must remain:

- `PubliclyAccessible = false`
- Encrypted
- In private DB subnets
- Reachable only from the ECS security group on port `5432`

## Fix Path

1. Confirm RDS is `available`.
2. Confirm ECS API tasks are in private app subnets.
3. Confirm `ecs -> rds` security group ingress exists on port `5432`.
4. Confirm the ECS execution role has `secretsmanager:GetSecretValue` on the RDS managed secret.
5. Confirm the API command builds `DATABASE_URL` with an encoded password.
6. Run the manual migration workflow only after the connection issue is fixed.
