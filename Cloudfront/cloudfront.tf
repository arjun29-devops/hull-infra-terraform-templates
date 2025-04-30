provider "aws" {
  alias  = "apsouth1"
  region = "ap-south-1"
}

resource "aws_cloudfront_distribution" "cloudfront-s3" {
  origin {
    domain_name = aws_s3_bucket.scorpio_cms_web.bucket_regional_domain_name
    origin_id   = "S3-scorpio-cms-web-stg"
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "scorpio_cms_web"
  default_root_object = "index.html"

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = "0"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_code            = "403"
    error_caching_min_ttl = "0"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-scorpio-cms-web-stg"

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }

    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = "arn:aws:acm:us-east-1:743515054768:certificate/733fd16f-7094-4c1a-8e85-c6c7962decfa"
    minimum_protocol_version       = "TLSv1.2_2018"
    ssl_support_method             = "sni-only"
  }

  aliases = ["scorpio-cms-stg.synergymarine.in"]
}
