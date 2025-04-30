# create ECR repo

resource "aws_ecr_repository" "ecr_repo" {
  name                 = "comm-svc-admin-ecr-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    Name        = "comm-svc-admin-ecr-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

resource "aws_ecr_repository" "event_ecr_repo" {
  name                 = "comm-svc-event-ecr-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    Name        = "comm-svc-event-ecr-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

resource "aws_ecr_repository" "pkg_create_ecr_repo" {
  name                 = "comm-svc-pkg-create-ecr-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    Name        = "comm-svc-pkg-create-ecr-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

resource "aws_ecr_repository" "pkg_trans_ecr_repo" {
  name                 = "comm-svc-pkg-trans-ecr-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    Name        = "comm-svc-pkg-trans-ecr-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

resource "aws_ecr_repository" "receiver_ecr_repo" {
  name                 = "comm-svc-receiver-ecr-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    Name        = "comm-svc-receiver-ecr-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

# Create S3 bucket for Application data's(Upload images, docs etc.)

resource "aws_s3_bucket" "communication_svc_s3" {
  bucket = "${var.ProjectName}-apiassets-${var.env}"
  acl    = "private"

  tags = {
    Name        = "${var.ProjectName}-apiassets-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}
