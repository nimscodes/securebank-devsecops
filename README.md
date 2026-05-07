# SecureBank

SecureBank is a production-style DevSecOps portfolio monorepo. Phase 1 creates the application foundation: a Next.js frontend, an Express API, PostgreSQL with Prisma, and local Docker orchestration. Phase 2 adds continuous integration, app validation, and security scanning with GitHub Actions. Phase 3 adds the Terraform AWS infrastructure foundation, Phase 4 prepares ECR, GitHub OIDC, and remote backend support, Phase 5A bootstraps GitHub OIDC and ECR, Phase 5B pushes images to ECR, Phase 5C deploys the AWS dev environment, and Phase 5D adds operational hardening.

## Repository Structure

```text
apps/
  web/        Next.js frontend with TypeScript and Tailwind
  api/        Node.js Express API with TypeScript and Prisma
infra/
  terraform/ Terraform modules, bootstrap environments, and dev environment
docs/         Project documentation
.github/
  workflows/ GitHub Actions CI and security workflows
```

## Prerequisites

- Node.js 20.11+
- npm 10.2+
- Docker and Docker Compose

## Local Development

1. Install dependencies:

   ```bash
   npm install
   ```

2. Create environment files:

   ```bash
   cp apps/web/.env.example apps/web/.env
   cp apps/api/.env.example apps/api/.env
   ```

3. Start PostgreSQL and pgAdmin:

   ```bash
   docker compose up -d postgres pgadmin
   ```

4. Generate Prisma client and run migrations:

   ```bash
   npm run prisma:generate -w apps/api
   npm run prisma:migrate -w apps/api
   ```

5. Run the applications:

   ```bash
   npm run dev
   ```

Frontend: http://localhost:3000  
API: http://localhost:4000  
pgAdmin: http://localhost:5050

pgAdmin credentials:

```text
Email: admin@securebank.dev
Password: securebank_admin
```

## Docker Development Stack

Build and run everything locally:

```bash
docker compose up --build
```

The stack includes:

- `web`: Next.js app on port 3000
- `api`: Express API on port 4000
- `postgres`: PostgreSQL on port 5432
- `pgadmin`: pgAdmin on port 5050

## Phase 1 Scope

- Next.js frontend with TypeScript and Tailwind
- Express API with TypeScript
- Prisma PostgreSQL connection
- Auth-ready domain models for users, accounts, and transactions
- Dockerfiles for frontend and API
- Docker Compose for app services and database tooling

## Phase 2 Scope

- GitHub Actions CI pipeline in `.github/workflows/ci.yml`
- App validation with `npm ci`, Prisma client generation, lint, typecheck, and build
- Dependency vulnerability checks with `npm audit --audit-level=high`
- Trivy filesystem security scan for high and critical vulnerabilities
- Checkov IaC scan against `infra/terraform` with soft-fail enabled while Terraform is placeholder-only
- Docker build validation for the API and web Dockerfiles without pushing images

Phase 2 does not include AWS deployment, ECR, ECS, OIDC, or Terraform infrastructure resources.

## Phase 3 Scope

- Modular Terraform foundation for VPC, security groups, ALB, ECS, RDS, Secrets Manager placeholders, and CloudWatch
- Dev environment under `infra/terraform/environments/dev`
- Cost guardrails with NAT gateway disabled by default
- Terraform validation only, with no `terraform apply`

## Phase 4 Scope

- ECR Terraform module for web and API image repositories
- GitHub Actions OIDC Terraform module scoped to `nimscodes/securebank-devsecops`
- Terraform backend bootstrap code for future S3 state and DynamoDB locking
- Safe Terraform plan workflow using OIDC placeholders
- Safe Docker build workflow that does not push images
- Deployment preparation documentation in `docs/deployment-prep.md`

AWS deployment, static credentials, ECR image publishing, remote backend activation, runtime security scanning, and production infrastructure are intentionally deferred to later phases.

## Phase 5A: AWS Bootstrap

Implemented the secure AWS automation foundation for the project:

- Created ECR repositories for web and API containers
- Configured ECR image lifecycle policies
- Created GitHub OIDC identity provider
- Created GitHub Actions IAM role with restricted trust policy
- Enabled GitHub Actions to authenticate to AWS without static access keys

No application infrastructure was deployed in this phase.

## Phase 5B: ECR Image Push

Added a GitHub Actions workflow that builds the web and API Docker images and pushes them to the existing Amazon ECR repositories from Phase 5A.

Required GitHub Actions repository variables:

```text
AWS_REGION
AWS_ROLE_ARN
WEB_ECR_REPOSITORY_URL
API_ECR_REPOSITORY_URL
```

The workflow uses GitHub OIDC to authenticate to AWS without static access keys. ECS deployment is not part of this phase.

## Current Deployed Architecture

```text
Internet
  -> public Application Load Balancer
  -> private ECS Fargate web and API services
  -> private encrypted RDS PostgreSQL
```

The dev environment uses:

- Public ALB for HTTP traffic
- Private ECS tasks for web and API containers
- Private RDS PostgreSQL with AWS-managed master password
- CloudWatch log groups for container output
- VPC endpoints for ECR, CloudWatch Logs, Secrets Manager, and S3 so NAT Gateway stays disabled
- Security groups enforcing internet -> ALB -> ECS -> RDS

## CI/CD Summary

- CI validates install, lint, typecheck, build, Docker builds, npm audit, Trivy, and Checkov.
- ECR push workflow builds and pushes web/API images using GitHub OIDC.
- Terraform plan workflow authenticates with GitHub OIDC and stops at plan.
- Database migration workflow is manual and runs Prisma migrations as a one-off ECS task.

## DevSecOps Controls

- No static AWS access keys in GitHub Actions
- GitHub OIDC role scoped to this repository
- RDS is private and encrypted
- Database password is AWS-managed and injected at runtime
- Terraform remote state bootstrap support with S3 and DynamoDB locking
- Security scanning with npm audit, Trivy, and Checkov
- CloudWatch alarms planned for ALB, ECS, target health, and RDS
- ALB access logging support is optional and disabled by default for dev cost control

## AWS Services Used

- Amazon VPC
- Application Load Balancer
- Amazon ECS on Fargate
- Amazon ECR
- Amazon RDS for PostgreSQL
- AWS Secrets Manager
- Amazon CloudWatch
- Amazon S3
- Amazon DynamoDB
- AWS IAM and GitHub OIDC

## Evidence

- `docs/evidence/phase-5c-deployment.md`
- `docs/evidence/phase-5d-hardening.md`

## Phase 5C: Dev Deployment

Deployed the first controlled AWS dev application environment.

Phase 5C keeps NAT Gateway disabled, uses the Phase 5A ECR images, keeps RDS private and encrypted, injects database connection settings into ECS without hardcoded passwords, and adds private AWS service endpoints so ECS tasks can pull images and write logs without public internet egress.

The deployed evidence is documented in `docs/evidence/phase-5c-deployment.md`.

## Phase 5D: Dev Hardening

Phase 5D prepares operational readiness for the deployed dev environment.

Added:

- Manual Prisma migration workflow using one-off ECS tasks
- CloudWatch alarms for ALB 5xx errors, ECS CPU/memory, unhealthy targets, RDS CPU, and RDS free storage
- Optional ALB access logging support with S3 retention controls
- Runbooks for rollback, API health check failures, database connection failures, and migrations

No Phase 5D Terraform changes should be applied until the plan is reviewed.
