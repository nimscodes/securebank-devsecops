# Phase 5A AWS Bootstrap Runbook

Phase 5A creates only the minimum AWS preparation resources:

- Terraform remote state S3 bucket
- DynamoDB lock table
- GitHub OIDC provider and role
- ECR repositories for web and API images

Do not apply ECS, ALB, RDS, VPC, NAT Gateway, or app deployment resources in this phase.

## Safer Apply Order

Run Phase 5A in this order:

1. Apply `infra/terraform/bootstrap/backend`
2. Apply `infra/terraform/bootstrap/oidc-ecr`
3. Configure GitHub repository variables
4. Run the Terraform Plan workflow
5. Do not apply `infra/terraform/environments/dev` until Phase 5B

The OIDC and ECR bootstrap is now separate from the dev environment, so Phase 5A does not require targeted applies from dev.

## Pre-Apply Checks

Run from the repository root:

```bash
git status --short
terraform version
aws --version
aws sts get-caller-identity
```

Set local shell values:

```bash
export AWS_REGION="us-east-1"
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export TF_STATE_BUCKET="securebank-dev-terraform-state-${AWS_ACCOUNT_ID}"
export TF_LOCK_TABLE="securebank-dev-terraform-locks"
export TF_STATE_KEY_PREFIX="securebank"
```

Confirm the values:

```bash
echo "$AWS_REGION"
echo "$AWS_ACCOUNT_ID"
echo "$TF_STATE_BUCKET"
echo "$TF_LOCK_TABLE"
```

Do not continue if the AWS account ID or region is wrong.

## 1. Bootstrap Terraform Backend

Run from:

```text
infra/terraform/bootstrap/backend
```

Create local-only variables:

```bash
cd infra/terraform/bootstrap/backend

cat > terraform.tfvars <<EOF
aws_region        = "${AWS_REGION}"
state_bucket_name = "${TF_STATE_BUCKET}"
lock_table_name   = "${TF_LOCK_TABLE}"

tags = {
  Owner = "platform"
}
EOF
```

Validate and plan:

```bash
terraform init -backend=false
terraform validate
terraform plan -out=backend-bootstrap.tfplan
terraform show backend-bootstrap.tfplan
```

Before applying, confirm the plan includes only:

```text
aws_s3_bucket
aws_s3_bucket_versioning
aws_s3_bucket_server_side_encryption_configuration
aws_s3_bucket_public_access_block
aws_s3_bucket_ownership_controls
aws_dynamodb_table
```

Approved apply command:

```bash
terraform apply backend-bootstrap.tfplan
```

Do not commit:

```text
terraform.tfvars
backend-bootstrap.tfplan
.terraform/
*.tfstate
```

## 2. Bootstrap GitHub OIDC and ECR

Run from:

```text
infra/terraform/bootstrap/oidc-ecr
```

Create local-only variables:

```bash
cd ../oidc-ecr

cat > terraform.tfvars <<EOF
aws_region     = "${AWS_REGION}"
aws_account_id = "${AWS_ACCOUNT_ID}"

project_name = "securebank"
environment  = "dev"

github_repository = "nimscodes/securebank-devsecops"
github_branch     = "main"

terraform_state_bucket_name = "${TF_STATE_BUCKET}"
terraform_lock_table_name   = "${TF_LOCK_TABLE}"
terraform_state_key_prefix  = "${TF_STATE_KEY_PREFIX}"

tags = {
  Owner = "platform"
}
EOF
```

Validate and plan:

```bash
terraform init -backend=false
terraform validate
terraform plan -out=oidc-ecr-bootstrap.tfplan
terraform show oidc-ecr-bootstrap.tfplan
```

Before applying, confirm the plan includes only ECR and IAM/OIDC resources, such as:

```text
aws_ecr_repository
aws_ecr_lifecycle_policy
aws_iam_openid_connect_provider
aws_iam_role
aws_iam_policy
aws_iam_role_policy_attachment
```

The plan must not include:

```text
aws_vpc
aws_subnet
aws_nat_gateway
aws_lb
aws_ecs_service
aws_db_instance
aws_security_group
aws_cloudwatch_log_group
aws_secretsmanager_secret
```

Approved apply command:

```bash
terraform apply oidc-ecr-bootstrap.tfplan
```

Capture outputs:

```bash
terraform output github_actions_role_arn
terraform output web_ecr_repository_url
terraform output api_ecr_repository_url
```

Do not commit:

```text
terraform.tfvars
oidc-ecr-bootstrap.tfplan
.terraform/
*.tfstate
```

## 3. Configure GitHub Repository Variables

In GitHub:

```text
Repository -> Settings -> Secrets and variables -> Actions -> Variables
```

Add:

```text
AWS_REGION = us-east-1
AWS_ROLE_ARN = <value from terraform output github_actions_role_arn>
```

Do not add static AWS credentials:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
```

## 4. Run Terraform Plan Safely

After GitHub variables are configured, run the GitHub workflow:

```text
Actions -> Terraform Plan -> Run workflow
```

Or open a pull request to `main`.

The workflow should run:

```text
terraform fmt -check
terraform init
terraform validate
terraform plan
```

It must not run:

```text
terraform apply
```

## 5. Keep Dev Unapplied Until Phase 5B

Do not apply:

```text
infra/terraform/environments/dev
```

The dev environment contains higher-cost application infrastructure such as VPC, ALB, ECS, RDS, security groups, CloudWatch app logs, and Secrets Manager app secret containers. Those resources are intentionally deferred until Phase 5B or later.

## AWS Console Verification

Verify backend bootstrap:

```text
S3 -> Buckets -> securebank-dev-terraform-state-<account-id>
```

Check:

```text
Versioning: enabled
Encryption: enabled
Block public access: enabled
```

Verify locking:

```text
DynamoDB -> Tables -> securebank-dev-terraform-locks
```

Check:

```text
Partition key: LockID
Billing mode: on-demand / pay-per-request
Encryption: enabled
```

Verify ECR:

```text
ECR -> Private repositories
```

Check:

```text
securebank-dev-web
securebank-dev-api
Scan on push: enabled
Encryption: AES256
Lifecycle policy: present
```

Verify OIDC:

```text
IAM -> Identity providers
```

Check:

```text
token.actions.githubusercontent.com
Audience: sts.amazonaws.com
```

Verify role:

```text
IAM -> Roles -> securebank-dev-github-actions-role
```

Check trust relationship is restricted to:

```text
nimscodes/securebank-devsecops
main branch
pull_request
```

## AWS Permissions Required

The human/admin identity running backend bootstrap needs permissions for:

```text
s3:CreateBucket
s3:PutBucketVersioning
s3:PutEncryptionConfiguration
s3:PutBucketPublicAccessBlock
s3:PutBucketOwnershipControls
s3:GetBucket*
s3:ListBucket
dynamodb:CreateTable
dynamodb:DescribeTable
dynamodb:UpdateTable
sts:GetCallerIdentity
```

The human/admin identity running OIDC/ECR bootstrap needs permissions for:

```text
ecr:CreateRepository
ecr:PutImageScanningConfiguration
ecr:PutImageTagMutability
ecr:PutLifecyclePolicy
ecr:DescribeRepositories
iam:CreateOpenIDConnectProvider
iam:GetOpenIDConnectProvider
iam:CreateRole
iam:CreatePolicy
iam:AttachRolePolicy
iam:GetRole
iam:GetPolicy
iam:TagRole
sts:GetCallerIdentity
```

## Cost Awareness

Expected low-cost or no-cost resources:

```text
DynamoDB on-demand lock table: usually tiny cost
S3 state bucket: low storage/versioning cost
ECR repositories: storage cost only when images are pushed
IAM OIDC provider and role: no direct cost
```

Do not create these yet:

```text
VPC
NAT Gateway
ALB
ECS/Fargate services
RDS
```

Higher-cost resources to avoid in Phase 5A:

```text
NAT Gateway
RDS
ALB
ECS running tasks
CloudWatch high-volume logs
```

## Rollback / Destroy Instructions

For ECR/OIDC rollback from:

```text
infra/terraform/bootstrap/oidc-ecr
```

Run only after explicit approval:

```bash
terraform destroy
```

Notes:

```text
ECR repositories may fail to delete if images exist.
Delete images first if needed.
This bootstrap state owns only OIDC and ECR resources.
```

For backend rollback from:

```text
infra/terraform/bootstrap/backend
```

The S3 bucket and DynamoDB table use `prevent_destroy = true`, so normal destroy is intentionally blocked.

Only if the backend is unused and rollback is explicitly approved:

```text
1. Empty all S3 object versions and delete markers.
2. Temporarily remove/comment prevent_destroy locally.
3. Run terraform destroy.
4. Restore the code afterward.
```

Do not commit that temporary rollback edit.

## Missing or Risky Settings Before First Apply

- `terraform.tfvars` values are placeholders and must be replaced locally.
- `aws_account_id = "000000000000"` must not be used for real apply.
- The dev environment must not be applied during Phase 5A.
- `thumbprint_list = []` validated locally, but verify AWS accepts it during real OIDC creation.
- Do not commit `terraform.tfvars`, `backend.tf`, `.terraform/`, `.tfstate`, `.tfplan`, AWS keys, or real secrets.

## Assumptions

- Phase 5A creates only backend, OIDC, and ECR when explicitly approved.
- No app deployment or ECR image push happens in this phase.
- ECS, ALB, RDS, VPC, and NAT Gateway remain unapplied.
