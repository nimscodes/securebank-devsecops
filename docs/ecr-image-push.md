# ECR Image Push

Phase 5B adds a GitHub Actions workflow that builds the SecureBank web and API Docker images and pushes them to the existing Amazon ECR repositories created in Phase 5A.

This phase does not deploy ECS, create new AWS resources, run Terraform, or use static AWS access keys.

## Workflow Overview

Workflow file:

```text
.github/workflows/ecr-push.yml
```

Workflow name:

```text
Build and Push Images to ECR
```

The workflow has two jobs:

- `build-and-push-web`
- `build-and-push-api`

Each job:

1. Checks out the repository.
2. Assumes the existing AWS IAM role through GitHub OIDC.
3. Logs in to Amazon ECR.
4. Builds the Docker image from the app Dockerfile.
5. Pushes two tags:
   - `latest`
   - the GitHub commit SHA

## Required GitHub Variables

Configure these in:

```text
GitHub repository -> Settings -> Secrets and variables -> Actions -> Variables
```

Required variables:

```text
AWS_REGION
AWS_ROLE_ARN
WEB_ECR_REPOSITORY_URL
API_ECR_REPOSITORY_URL
```

Do not add static AWS credentials:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
```

## Triggers

The workflow runs manually with:

```text
Actions -> Build and Push Images to ECR -> Run workflow
```

It also runs on pushes to `main` when relevant app, package, Docker Compose, or workflow files change.

## Manual Run

1. Confirm the required GitHub variables are configured.
2. Open the GitHub repository.
3. Go to `Actions`.
4. Select `Build and Push Images to ECR`.
5. Select `Run workflow`.
6. Run the workflow from `main`.

Expected result:

- GitHub assumes the AWS role through OIDC.
- Docker builds both images.
- ECR receives `latest` and commit-SHA tags for each image.

## Verify Images in AWS ECR

In the AWS Console:

```text
ECR -> Private repositories
```

Open:

```text
securebank-dev-web
securebank-dev-api
```

Confirm each repository has:

- `latest` tag
- commit SHA tag
- image scan status
- recent push time

You can also verify with AWS CLI:

```bash
aws ecr describe-images --repository-name securebank-dev-web --region us-east-1
aws ecr describe-images --repository-name securebank-dev-api --region us-east-1
```

## Rollback and Delete Image Notes

This phase only pushes images. It does not update ECS services or deploy the app, so rollback is just choosing an older image tag in a later deployment phase.

To delete a bad image manually:

```bash
aws ecr batch-delete-image \
  --repository-name securebank-dev-web \
  --image-ids imageTag=<tag> \
  --region us-east-1
```

Use the API repository name for API image cleanup:

```bash
aws ecr batch-delete-image \
  --repository-name securebank-dev-api \
  --image-ids imageTag=<tag> \
  --region us-east-1
```

Be careful deleting tags that a later deployment may reference.

## Troubleshooting

Missing GitHub variable:

```text
Missing GitHub repository variable: AWS_ROLE_ARN
```

Fix by adding the required variable in GitHub Actions variables.

OIDC assume-role failure:

```text
Not authorized to perform sts:AssumeRoleWithWebIdentity
```

Check that `AWS_ROLE_ARN` matches the Phase 5A role and that the IAM trust policy allows `nimscodes/securebank-devsecops`.

ECR push denied:

```text
AccessDeniedException
```

Check that the GitHub Actions IAM policy allows ECR push actions for both repositories.

Docker build failure:

```text
failed to solve
```

Run the local Docker build commands from the repo root:

```bash
docker build -f apps/web/Dockerfile -t securebank-web:test .
docker build -f apps/api/Dockerfile -t securebank-api:test .
```

Repository URL typo:

```text
name unknown
```

Verify `WEB_ECR_REPOSITORY_URL` and `API_ECR_REPOSITORY_URL` match the Phase 5A ECR repository outputs.
