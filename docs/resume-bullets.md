# Resume Bullets

These are draft bullets for tailoring a resume. Pick the role that matches the job and adjust the wording to fit the rest of the resume.

## Cloud Engineer

- Built modular AWS infrastructure with Terraform, including VPC networking, ALB, ECS Fargate, private RDS PostgreSQL, ECR, CloudWatch, WAF, S3, DynamoDB, and IAM.
- Designed a private runtime path where public traffic reaches an ALB, ECS services run in private subnets, and only the API can reach RDS.
- Kept dev infrastructure cost-aware by disabling NAT Gateway by default and using VPC endpoints for ECR, CloudWatch Logs, Secrets Manager, and S3.
- Separated Terraform bootstrap resources from application infrastructure to make backend state, OIDC, and ECR setup easier to manage.

## DevOps Engineer

- Created GitHub Actions workflows for CI validation, Docker builds, ECR image push, Terraform plan, and manual database migrations.
- Built and pushed web/API Docker images to Amazon ECR using GitHub OIDC instead of static AWS credentials.
- Added Terraform plan review before apply so infrastructure changes could be inspected before deployment.
- Wrote rollback, health check, database connection, migration, and cleanup runbooks for day-two operations.

## DevSecOps Engineer

- Added CI security checks with npm audit, Trivy filesystem scans, and Checkov IaC scanning.
- Replaced long-lived AWS keys with GitHub OIDC and a repository-scoped IAM role.
- Added AWS WAF, security headers, private RDS, encrypted storage, and Secrets Manager integration.
- Documented security controls, IAM wildcard rationale, compliance mapping, and deployment evidence.

## Site Reliability Engineer

- Added CloudWatch alarms for ALB 5xx errors, unhealthy targets, ECS CPU/memory, RDS CPU, and RDS free storage.
- Validated ECS service rollout, ALB target health, API `/health`, RDS privacy, encryption, and CloudWatch logging.
- Wrote runbooks for rollback, API health check failures, database connection failures, and migration issues.
- Added an AWS cleanup guide to reduce ongoing dev costs after demos.

## Cloud Security Engineer

- Implemented defense-in-depth controls across CI/CD, IAM, network design, runtime services, and documentation.
- Scoped AWS automation through GitHub OIDC, least-privilege ECR permissions, Terraform plan permissions, and documented required wildcard permissions.
- Configured AWS WAF in count mode with managed rules for common threats, known bad inputs, IP reputation, and SQL injection.
- Mapped project controls to OWASP Top 10, NIST SSDF, CIS AWS Foundations concepts, and DevSecOps practices.
