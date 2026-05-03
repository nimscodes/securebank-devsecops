# Terraform Backend Bootstrap

This folder defines the S3 bucket and DynamoDB table that will support a future Terraform remote backend.

Run this folder manually only in a later bootstrap step. Do not run `terraform apply` during Phase 4.

Safe validation:

```bash
terraform init -backend=false
terraform validate
```

When a future phase approves backend creation, apply this bootstrap first, then configure environment backends to use the created S3 bucket and DynamoDB table.
