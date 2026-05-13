# Architecture

SecureBank is a DevSecOps platform with local development, CI/CD automation, container delivery, AWS infrastructure as code, monitoring, and security controls.

The AWS dev environment is Terraform-managed and can be destroyed after demos to control cost. The diagram below shows the environment when it is deployed.

## High-Level Architecture

```mermaid
flowchart TD
  developer["Developer"] --> repo["GitHub Repository"]
  repo --> actions["GitHub Actions"]

  actions --> ci["CI Validation<br/>lint, typecheck, build"]
  actions --> scans["Security Scans<br/>npm audit, Trivy, Checkov"]
  actions --> ecrPush["ECR Push Workflow<br/>OIDC auth"]
  actions --> tfPlan["Terraform Plan Workflow<br/>OIDC auth"]
  actions --> migration["Manual Migration Workflow<br/>one-off ECS task"]

  ecrPush --> ecr["Amazon ECR<br/>web and API images"]

  user["User"] --> waf["AWS WAF<br/>managed rules in count mode"]
  waf --> alb["Public ALB<br/>HTTP listener and headers"]
  alb --> web["ECS Fargate Web<br/>private app subnet"]
  alb --> api["ECS Fargate API<br/>private app subnet"]

  ecr --> web
  ecr --> api
  migration --> api

  api --> rds["RDS PostgreSQL<br/>private and encrypted"]
  api --> secrets["Secrets Manager<br/>managed DB password"]

  web --> logs["CloudWatch Logs"]
  api --> logs
  alb --> alarms["CloudWatch Alarms"]
  api --> alarms
  rds --> alarms

  tfPlan --> terraform["Terraform Modules<br/>VPC, ALB, ECS, RDS, WAF"]
```

## Request Flow

```mermaid
sequenceDiagram
  participant User
  participant WAF as AWS WAF
  participant ALB as Application Load Balancer
  participant Web as ECS Web Service
  participant API as ECS API Service
  participant DB as Private RDS PostgreSQL

  User->>WAF: HTTP request
  WAF->>ALB: Allowed or counted request
  ALB->>Web: Frontend route
  ALB->>API: /api/* or /health route
  API->>DB: PostgreSQL connection
  DB-->>API: Query result
  API-->>ALB: API response
  Web-->>ALB: Frontend response
  ALB-->>User: HTTP response with security headers
```

## CI/CD Flow

```mermaid
flowchart LR
  push["Push or Pull Request"] --> validate["Install, Lint, Typecheck, Build"]
  validate --> scan["npm audit, Trivy, Checkov"]
  scan --> docker["Docker Build Validation"]
  docker --> ecr["Optional ECR Push on main"]
  ecr --> plan["Terraform Plan with OIDC"]
  plan --> review["Human Review"]
  review --> apply["Manual Terraform Apply<br/>approved only"]
```

## Security Flow

```mermaid
flowchart TD
  code["Source Code"] --> depScan["Dependency and Filesystem Scans"]
  code --> iacScan["IaC Scan"]
  gha["GitHub Actions"] --> oidc["OIDC AssumeRole<br/>no static keys"]
  oidc --> aws["AWS IAM Role"]
  internet["Internet"] --> waf["WAF Managed Rules"]
  waf --> headers["ALB and App Security Headers"]
  headers --> privateApp["Private ECS Tasks"]
  privateApp --> privateDb["Private Encrypted RDS"]
  privateApp --> secrets["Secrets Manager"]
```

## Monitoring Flow

```mermaid
flowchart TD
  web["ECS Web"] --> webLogs["CloudWatch Web Logs"]
  api["ECS API"] --> apiLogs["CloudWatch API Logs"]
  alb["ALB"] --> albMetrics["ALB Metrics"]
  ecs["ECS Services"] --> ecsMetrics["ECS CPU and Memory"]
  rds["RDS"] --> rdsMetrics["RDS CPU and Storage"]

  albMetrics --> alarms["CloudWatch Alarms"]
  ecsMetrics --> alarms
  rdsMetrics --> alarms
  webLogs --> runbooks["Operational Runbooks"]
  apiLogs --> runbooks
  alarms --> runbooks
```

## Network Boundaries

- Public: ALB only
- Private app tier: ECS web and API tasks
- Private database tier: RDS PostgreSQL
- Secrets: Secrets Manager, referenced by ECS runtime configuration
- Observability: CloudWatch logs and alarms

## Cost Boundary

NAT Gateway is disabled by default. The dev environment uses VPC endpoints for required AWS service access and can be destroyed after demos to control AWS cost.
