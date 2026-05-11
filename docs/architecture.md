# Architecture

SecureBank is a DevSecOps portfolio platform with local development, CI/CD automation, container delivery, deployed AWS dev infrastructure, monitoring, and security controls.

## AWS Dev Architecture

```mermaid
flowchart TD
  developer["Developer"] --> github["GitHub Repository"]
  github --> actions["GitHub Actions"]
  actions --> scans["CI Security Scans<br/>npm audit, Trivy, Checkov"]
  actions --> ecr["Amazon ECR<br/>web/api images"]
  actions --> tfplan["Terraform Plan<br/>OIDC auth"]
  actions --> migrate["Manual Migration Workflow<br/>one-off ECS task"]

  user["User"] --> waf["AWS WAF<br/>managed rules in count mode"]
  waf --> alb["Public ALB<br/>security headers"]
  alb --> web["ECS Fargate Web<br/>private subnet"]
  alb --> api["ECS Fargate API<br/>private subnet"]
  api --> rds["RDS PostgreSQL<br/>private, encrypted"]
  api --> secrets["Secrets Manager<br/>RDS managed password"]
  web --> logs["CloudWatch Logs"]
  api --> logs
  alb --> alarms["CloudWatch Alarms"]
  rds --> alarms
  api --> alarms

  ecr --> web
  ecr --> api
  migrate --> api
  tfplan --> aws["AWS Infrastructure<br/>Terraform-managed"]
```

## Request Flow

```text
Internet -> AWS WAF -> ALB -> ECS web/API -> private RDS
```

## Deployment Flow

```text
GitHub Actions -> OIDC -> ECR image push -> Terraform plan review -> controlled apply
```

## Security Flow

```text
CI scans -> OIDC auth -> WAF telemetry -> security headers -> private network tiers -> CloudWatch alarms
```
