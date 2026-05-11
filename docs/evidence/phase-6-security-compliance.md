# Phase 6 Security and Compliance Evidence

## Scope

Phase 6 adds the security and compliance layer for the deployed SecureBank AWS dev platform.

## Planned Controls

- AWS WAF attached to the public ALB
- AWS managed WAF rule groups in count mode by default
- ALB and app-layer security headers
- GitHub OIDC IAM policy review
- Compliance mapping documentation
- Architecture diagram source

## WAF Managed Rule Groups

- AWSManagedRulesCommonRuleSet
- AWSManagedRulesKnownBadInputsRuleSet
- AWSManagedRulesAmazonIpReputationList
- AWSManagedRulesSQLiRuleSet

## Validation

Phase 6 stops after:

```bash
npm run lint --workspaces
npm run typecheck --workspaces
npm run build --workspaces
terraform fmt -recursive infra/terraform
cd infra/terraform/environments/dev
terraform validate
terraform plan -out=phase6-security-compliance.tfplan
```

## Apply Status

Phase 6 is not applied automatically. The Terraform plan must be reviewed before any apply.
