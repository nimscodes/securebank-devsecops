# Security Controls

SecureBank layers security controls across source control, CI/CD, container delivery, AWS networking, runtime services, monitoring, and evidence.

## Edge Protection

- Public ingress terminates at the Application Load Balancer.
- AWS WAF is configured for the public ALB in Phase 6.
- WAF managed rule groups run in count mode by default for dev so matches can be reviewed before blocking is enabled.
- Managed rule groups include common web exploits, known bad inputs, IP reputation, and SQL injection coverage.

## Security Headers

- API responses use Helmet with HSTS disabled until HTTPS is introduced.
- Web responses use Next.js security headers.
- ALB listener response headers add defense in depth for:
  - `X-Content-Type-Options`
  - `X-Frame-Options`
  - `Content-Security-Policy`
- `Referrer-Policy` is set at the app layer.
- `Strict-Transport-Security` is intentionally deferred until HTTPS/ACM is enabled.

## Network Boundaries

- Public ingress is limited to the ALB.
- ECS services run in private application subnets.
- RDS PostgreSQL runs in private database subnets and is not publicly accessible.
- Security groups enforce traffic flow from internet to ALB, ALB to ECS, and ECS to RDS.
- NAT Gateway remains disabled for dev cost control.
- Private VPC endpoints allow ECS tasks to reach ECR, CloudWatch Logs, Secrets Manager, and S3 without public internet egress.

## Secrets

- No real secrets are stored in the repository.
- RDS uses AWS-managed master password support.
- ECS injects database credentials at runtime from Secrets Manager.
- Terraform examples use placeholders only.

## IAM Controls

- GitHub Actions uses OIDC instead of static AWS keys.
- ECR push/pull is scoped to the SecureBank web and API repositories.
- Terraform backend access is scoped to the configured state bucket prefix and lock table.
- ECS migration task execution is scoped to the API task definition, ECS cluster, and ECS task roles.

Remaining wildcard permissions:

- `ecr:GetAuthorizationToken` requires `Resource = "*"`.
- Terraform read-only plan permissions use several list/describe actions that AWS requires or commonly evaluates with `Resource = "*"`.
- ECS task/service describe permissions remain wildcard because ECS describe/list APIs do not support practical resource scoping for the workflow inputs.

## Logging and Monitoring

- ECS web and API services write logs to CloudWatch.
- CloudWatch alarms cover ALB 5xx, target health, ECS CPU/memory, RDS CPU, and RDS free storage.
- ALB access logging support exists but remains disabled by default until log storage cost is accepted.

## CI/CD Security

- CI runs lint, typecheck, build, Docker build validation, npm audit, Trivy, and Checkov.
- ECR image publishing uses GitHub OIDC.
- Database migrations are manual and run as one-off ECS tasks.
- Terraform plan workflow stops at plan and does not apply infrastructure automatically.
