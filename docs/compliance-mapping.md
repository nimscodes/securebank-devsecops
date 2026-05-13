# Compliance Mapping

This document maps SecureBank controls to common security and compliance concepts. It is not a formal certification.

## OWASP Top 10

| OWASP Area | SecureBank Control |
| --- | --- |
| A01 Broken Access Control | ALB-only ingress, private ECS/RDS, security-group boundaries |
| A02 Cryptographic Failures | Encrypted RDS, AWS-managed DB password, no committed secrets |
| A03 Injection | Prisma parameterization, WAF SQLi managed rule group in count mode |
| A04 Insecure Design | Modular Terraform, private network tiers, runbooks, rollback guidance |
| A05 Security Misconfiguration | Helmet, Next.js headers, ALB headers, Checkov scanning |
| A06 Vulnerable Components | npm audit and Trivy in CI |
| A07 Identification/Auth Failures | Auth-ready data model; no production auth claims made yet |
| A08 Software/Data Integrity Failures | GitHub Actions CI, Docker build validation, ECR lifecycle controls |
| A09 Logging/Monitoring Failures | CloudWatch logs and alarms, ALB access logging support |
| A10 SSRF | Private subnets, no NAT Gateway, restricted service egress through VPC endpoints |

## NIST SSDF

| SSDF Practice | SecureBank Control |
| --- | --- |
| PO.1 Define security requirements | Phase docs, security controls, runbooks |
| PO.3 Implement supporting toolchains | GitHub Actions CI/CD, Terraform, Prisma, Docker |
| PS.1 Protect source code | Git history, no secrets committed, OIDC instead of static keys |
| PS.3 Archive and protect releases | ECR repositories with lifecycle policy |
| PW.4 Reuse secure components | AWS managed WAF rules, Helmet, Prisma, managed RDS password |
| PW.7 Review and analyze code | lint, typecheck, build, npm audit, Trivy, Checkov |
| RV.1 Identify vulnerabilities | CI scanning and WAF telemetry |
| RV.3 Analyze vulnerabilities | runbooks and evidence docs |

## CIS AWS Foundations Concepts

| CIS Concept | SecureBank Control |
| --- | --- |
| Identity and access management | OIDC role, scoped ECR/backend/migration permissions |
| Logging and monitoring | CloudWatch logs, CloudWatch alarms, optional ALB access logs |
| Networking | public ALB, private ECS/RDS, security groups, no public RDS |
| Storage protection | encrypted RDS, encrypted state bucket bootstrap, ECR scanning |
| Secrets management | Secrets Manager and AWS-managed RDS password |

## DevSecOps Controls

- Security checks run in CI before merge.
- Images are built and pushed through auditable GitHub Actions workflows.
- Terraform plans are reviewed before apply.
- Runtime alarms detect common service and database health issues.
- Runbooks document rollback, health check failures, database failures, and migrations.
- Evidence documents capture deployed-state proof for review.
