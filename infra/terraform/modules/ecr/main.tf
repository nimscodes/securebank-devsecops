locals {
  repositories = {
    web = {
      name = var.web_repository_name
    }
    api = {
      name = var.api_repository_name
    }
  }
}

resource "aws_ecr_repository" "this" {
  for_each = local.repositories

  name                 = each.value.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(var.tags, {
    Name    = each.value.name
    Service = each.key
  })
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = aws_ecr_repository.this

  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep the most recent tagged images."
        selection = {
          tagStatus   = "tagged"
          countType   = "imageCountMoreThan"
          countNumber = var.max_tagged_images
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Expire old untagged images."
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.untagged_image_expiration_days
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
