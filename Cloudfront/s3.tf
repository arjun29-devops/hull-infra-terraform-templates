# Create S3 bucket for Application data's(Upload images, docs etc.)

resource "aws_s3_bucket" "scorpio_cms_web" {
  bucket = "${var.ProjectName}-${var.env}"
  acl    = "public-read"
  policy = file("policy.json")

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name        = "${var.ProjectName}-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}
