variable "project_name" {
  description = "The name to use of all cluster resources { Recommended format: app-name_environment } e.g. terraform_staging"
  type = string
}

variable "env" {
  description = "Environment in which application is supposed to be deployed e.g dev/staging/prod"
  type = string
}

variable "bucket_name" {
  description = "Name of the bucket to be created"
  type = string
}

variable "created_by" {
  type = string
}

variable "domain_alias" {
  description = "Domain which will point to the cloudfront"
  type = string
}

variable "ssl_certificate_arn" {
  description = "ARN of the acm certificate for cloudfront"
  type = string
}
variable "cors_allowed_origins" {
  type = list(string)
  default = [""]
}
