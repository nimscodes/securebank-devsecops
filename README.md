# SecureBank

SecureBank is a production-style DevSecOps portfolio monorepo. Phase 1 creates the application foundation: a Next.js frontend, an Express API, PostgreSQL with Prisma, and local Docker orchestration. Phase 2 adds continuous integration, app validation, and security scanning with GitHub Actions. Phase 3 adds the Terraform AWS infrastructure foundation, Phase 4 prepares ECR, GitHub OIDC, and remote backend support without deployment, and Phase 5A bootstraps GitHub OIDC and ECR for safe AWS automation.

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
