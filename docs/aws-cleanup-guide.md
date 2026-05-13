# AWS Cleanup Guide

Use this guide to reduce AWS costs after demos or testing. The safest approach is to destroy the Terraform-managed dev application environment while preserving low-cost bootstrap resources for future redeployment.

## What To Back Up First

Before destroying resources, decide whether you need:

- Database data
- RDS snapshot
- CloudWatch log evidence
- Terraform outputs
- Screenshots for project evidence
- ECR image tags for future deployment

Do not download or commit secrets, passwords, `.tfvars`, Terraform state, or private keys.

## Recommended Destroy Order

1. Destroy the dev application environment.
2. Optionally clean ECR images.
3. Keep backend and OIDC/ECR bootstrap resources unless fully retiring the project.
4. Only destroy backend resources after state is no longer needed.

## Destroy Dev Application Infrastructure

From:

```bash
cd infra/terraform/environments/dev
```

Create and review a destroy plan:

```bash
terraform plan -destroy -out=destroy-dev.tfplan
terraform show destroy-dev.tfplan
```

Apply only after confirming the plan targets dev resources such as ECS, ALB, RDS, VPC, WAF, CloudWatch, Secrets Manager placeholders, and security groups:

```bash
terraform apply destroy-dev.tfplan
```

Remove the local plan file afterward:

```bash
rm destroy-dev.tfplan
```

Do not commit `.tfplan`, `.tfstate`, `.terraform`, or `terraform.tfvars` files.

## Resources Usually Removed By Dev Destroy

- ECS cluster, services, and task definitions
- ALB, listeners, rules, and target groups
- RDS PostgreSQL
- VPC, subnets, route tables, internet gateway, and endpoints
- Security groups
- WAF Web ACL association and Web ACL if applied in dev
- CloudWatch alarms and log groups
- Secrets Manager placeholder secrets

## Resources Usually Kept

These are lower cost and useful for redeployment:

- Terraform backend S3 bucket
- DynamoDB lock table
- ECR repositories
- GitHub OIDC provider and IAM role

## ECR Image Cleanup

ECR repositories can charge for stored images. To reduce cost, delete old image tags from the AWS Console or with AWS CLI.

Use caution:

- Keep at least one known-good image if you plan to redeploy soon.
- The lifecycle policy should clean old images over time.
- Empty repositories before destroying ECR resources.

## RDS Snapshot Consideration

Before destroying RDS, decide whether a final snapshot is needed.

For a short-lived dev environment, skipping a final snapshot may be acceptable to reduce storage cost. For production, final snapshots and restore testing would be required.

## Manual AWS Console Checks After Destroy

Check the following AWS Console areas:

- ECS: no running dev services or tasks
- EC2 Load Balancers: dev ALB removed
- RDS: dev database removed or intentionally stopped
- VPC: dev VPC and endpoints removed
- WAF: dev Web ACL removed if no longer needed
- CloudWatch: old log groups reviewed
- ECR: repositories/images reviewed
- S3: Terraform backend bucket preserved only if still needed
- DynamoDB: lock table preserved only if still needed

## Avoiding Orphaned Resources

- Prefer Terraform destroy over manual console deletion.
- If manual deletion is unavoidable, run `terraform plan` afterward to detect drift.
- Do not delete the backend bucket while Terraform state still depends on it.
- Do not destroy ECR repositories before deleting images if deletion protection or non-empty repository settings block removal.

## Full Retirement

Only when fully retiring the project:

1. Destroy dev environment.
2. Destroy OIDC/ECR bootstrap after cleaning ECR images.
3. Back up or intentionally discard Terraform state.
4. Remove backend protection only with explicit approval.
5. Destroy backend S3 bucket and DynamoDB lock table.

The backend bootstrap intentionally includes protections because deleting state storage too early can make recovery harder.
