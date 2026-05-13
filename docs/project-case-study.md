# SecureBank Project Case Study

## Short Version

SecureBank is a small banking-style app wrapped in a real DevSecOps workflow. I used it to practice the work a cloud engineer is expected to do around an application: build automation, image delivery, Terraform infrastructure, AWS deployment, monitoring, security controls, documentation, and cleanup.

The application itself is intentionally simple. The platform work is the point.

## Problem

I wanted a project that showed more than "I deployed something to AWS." A real team needs to know:

- how code is validated before it ships
- how cloud access is handled without static keys
- how infrastructure changes are reviewed
- how the app is monitored after deployment
- how database changes are handled
- how to shut things down without leaving expensive resources behind

SecureBank was built around those questions.

## Architecture Choices

I used ECS Fargate because it gives a realistic container platform without having to manage EC2 worker nodes. The app sits behind an Application Load Balancer. The web and API services run in private subnets, and PostgreSQL runs in private database subnets.

The network path is simple on purpose:

```text
Internet -> ALB -> ECS web/API -> private RDS PostgreSQL
```

For image delivery, GitHub Actions builds Docker images and pushes them to ECR. ECS pulls from ECR through VPC endpoints, so the dev environment can keep NAT Gateway disabled.

## Security Choices

The most important security decision was using GitHub OIDC instead of AWS access keys. GitHub Actions assumes an IAM role at runtime, and the role trust policy is scoped to this repository.

Other controls include:

- private RDS
- encrypted RDS storage
- AWS-managed database password
- security groups between ALB, ECS, and RDS
- WAF attached to the ALB
- security headers at the app and ALB layers
- npm audit, Trivy, and Checkov in CI
- Terraform state prepared for S3 encryption and DynamoDB locking

WAF starts in count mode because blocking traffic on day one can create false positives. In a production rollout, I would watch WAF matches first, tune exclusions, then move selected rules into block mode.

## CI/CD Choices

The workflows are split by job:

- CI checks app quality and security.
- Docker build validates container builds.
- ECR push publishes images.
- Terraform plan reviews infrastructure changes.
- Database migrations run manually.

I kept Terraform apply out of the normal push flow. That makes the project slower than full automation, but safer and easier to review.

## Infrastructure Choices

Terraform is organized into modules so each part of the stack has a clear boundary:

- VPC
- security groups
- ALB
- ECS
- RDS
- Secrets Manager
- CloudWatch
- ECR
- GitHub OIDC
- WAF

Bootstrap resources are separate from the dev environment. That helped avoid using targeted applies from the main environment for foundational resources like backend state, OIDC, and ECR.

## Monitoring Choices

I added alarms for the signals I would check first during an incident:

- ALB 5xx errors
- unhealthy target count
- ECS CPU and memory
- RDS CPU
- RDS free storage

The repo also includes runbooks for rollback, API health check failures, database connection issues, and migrations.

## Issues I Ran Into

A few realistic issues came up:

- GitHub Actions workflow syntax needed careful validation.
- Terraform backend and OIDC bootstrap needed to be separated from app infrastructure.
- ECS needed access to ECR, CloudWatch Logs, and Secrets Manager without NAT Gateway.
- RDS creation and deletion are slow, so long-running Terraform operations had to be handled patiently.
- Secrets Manager keeps deleted secrets in a recovery window, which can block immediate redeployment with the same names.

## How I Resolved Them

- Split workflows so each one has a clear job.
- Created separate Terraform bootstrap folders.
- Added VPC endpoints for ECR, Logs, Secrets Manager, and S3.
- Kept NAT Gateway disabled by default.
- Restored scheduled-for-deletion placeholder secrets and imported them back into Terraform state when redeploying.
- Added cleanup guidance so the dev stack can be destroyed after demos.

## Current Outcome

SecureBank now has:

- local Docker development
- CI/CD validation and security scans
- ECR image publishing
- modular Terraform
- AWS dev deployment
- private database design
- CloudWatch monitoring
- WAF and security headers
- runbooks and evidence docs
- cleanup instructions

## What I Would Improve For Production

- Add HTTPS with ACM and Route 53.
- Add staging and production environments.
- Move WAF rules from count to block after review.
- Add blue/green or canary deployment.
- Add stronger application authentication and authorization.
- Add restore testing for RDS backups.
- Use RDS Multi-AZ for production.
- Send alerts to Slack, email, or an incident tool.
- Add more application tests before deployment.
