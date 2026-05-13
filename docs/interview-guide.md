# SecureBank Interview Guide

## 60-Second Pitch

SecureBank is a DevSecOps project built around a small banking-style app. I used Next.js, Express, Prisma, Docker, GitHub Actions, Terraform, and AWS. The important part is the platform: CI checks, security scans, ECR image push, GitHub OIDC, ECS Fargate, private RDS, CloudWatch alarms, WAF, runbooks, and cleanup docs. It shows that I can think past deployment and into security, operations, and cost control.

## 2-Minute Walkthrough

The repo is a monorepo with the web app, API, Terraform, docs, and GitHub Actions workflows.

Locally, Docker Compose runs PostgreSQL, pgAdmin, the API, and the web app. The API uses Prisma and has a `/health` endpoint.

In CI, GitHub Actions runs install, lint, typecheck, build, Prisma generation, npm audit, Trivy, Checkov, and Docker build validation.

For AWS, Terraform defines the network, ALB, ECS services, RDS, Secrets Manager placeholders, CloudWatch alarms, ECR, GitHub OIDC, and WAF. GitHub Actions authenticates to AWS with OIDC instead of static keys.

The dev stack has been deployed and validated. ECS services reached 1/1 running, target groups were healthy, the web route returned HTTP 200, and `/health` returned database connected.

## STAR Story

Situation: I wanted a portfolio project that looked closer to real cloud work than a basic app deployment.

Task: Build a secure AWS deployment workflow with CI/CD, infrastructure as code, monitoring, and documentation while keeping costs under control.

Action: I built the app foundation, added Docker, created GitHub Actions workflows, wrote Terraform modules, configured OIDC, deployed to ECS Fargate, added private RDS, CloudWatch alarms, WAF, runbooks, and evidence. I also destroyed and redeployed the dev stack to prove the infrastructure could be recreated.

Result: The repo now shows the full path from local development to secure AWS deployment, plus the operational details needed to explain it in an interview.

## Questions And Answers

### Why ECS Fargate?

Fargate lets me run containers without managing EC2 instances. It still gives me real AWS deployment concepts: task definitions, services, target groups, IAM roles, logs, and private networking.

### Why Terraform?

Terraform makes the infrastructure repeatable and reviewable. A plan shows what will change before anything is applied, which is important when working with cloud resources that cost money.

### Why GitHub OIDC?

OIDC avoids storing AWS access keys in GitHub. The workflow gets temporary AWS credentials by assuming a role that is scoped to this repository.

### Why private RDS?

The database should not be public. In this design, only the API service can reach RDS through security groups. The database is also encrypted.

### How did you secure the pipeline?

I used OIDC, scoped IAM, npm audit, Trivy, Checkov, Docker build checks, and Terraform plan review. Apply is manual instead of happening automatically on every push.

### How did you monitor the app?

CloudWatch collects logs from the web and API containers. Alarms track ALB 5xx errors, unhealthy targets, ECS CPU/memory, RDS CPU, and RDS free storage.

### How would you roll back a bad deployment?

For an image issue, I would redeploy a previous image tag. For infrastructure, I would revert the Terraform change, run a new plan, review it, and apply it manually. For database issues, I would stop and follow the migration runbook instead of rerunning migrations blindly.

### How would you handle a failed database migration?

I would check the migration logs, confirm whether the migration partially applied, avoid running destructive changes again, restore from backup if needed, and write a corrected migration. In production, I would test migrations in staging first.

### What would you improve for production?

I would add HTTPS with ACM, Route 53, separate staging/prod environments, WAF block mode after tuning, blue/green deploys, RDS Multi-AZ, stronger auth, backup restore testing, and alert routing.

### What was the hardest part?

The sequencing. Backend state, OIDC, ECR, images, app infrastructure, migrations, monitoring, and WAF all depend on each other. Splitting the project into phases kept the work understandable and safer.
