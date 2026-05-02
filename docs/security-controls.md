# Security Controls

Phase 3 adds AWS infrastructure-as-code security foundations without deploying resources.

## Network Boundaries

- Public ingress is limited to the application load balancer.
- ECS services are placed in private application subnets.
- RDS PostgreSQL is placed in private database subnets and is not publicly accessible.
- Security groups enforce traffic flow from internet to ALB, ALB to ECS, and ECS to RDS.

## Secrets

- No real secrets are stored in the repository.
- Secrets Manager resources are placeholders only and do not create secret values.
- RDS is configured to use AWS-managed master user password support.

## Logging

- ECS web and API services send logs to dedicated CloudWatch log groups.
- Log retention is configurable by environment.

## CI Scanning

- Phase 2 Checkov scanning remains enabled in soft-fail mode while Terraform is still foundational.
- Trivy filesystem scanning continues to run for high and critical issues.
