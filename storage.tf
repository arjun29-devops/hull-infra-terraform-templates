# create ECR repo

resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.ProjectName}-ecr-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    Name        = "${var.ProjectName}-ecr-${var.env}"
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
