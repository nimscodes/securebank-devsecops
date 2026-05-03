locals {
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = "bootstrap"
    ManagedBy   = "terraform"
  })
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket_name

  # Keep this protected after the backend is manually applied. State buckets
  # should not be destroyed casually because they contain infrastructure history.
  lifecycle {
    prevent_destroy = true
  }

  tags = merge(local.common_tags, {
    Name = var.state_bucket_name
  })
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  # Keep this protected after manual bootstrap. The lock table protects state
  # consistency for future remote backend operations.
  lifecycle {
    prevent_destroy = true
  }

  tags = merge(local.common_tags, {
    Name = var.lock_table_name
  })
}
