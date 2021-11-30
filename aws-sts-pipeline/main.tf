provider "aws" {
  region     = "us-east-1"
}

module "dev_bucket" {
  source  = "app.terraform.io/jacobm3/s3_simple/aws"
  version = "2.6.0"
  bucket_name = "terraform-bucket"
}

output "bucket_endpoint" {
    value = "${module.dev_bucket.website_bucket_id}"
}

output "bucket_domain_name" {
    value = "${module.dev_bucket.bucket_domain_name}"
}

output "bucket_arn" {
    value = "${module.dev_bucket.bucket_arn}"
}


