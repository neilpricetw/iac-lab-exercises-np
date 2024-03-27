module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.1"

  bucket = format("%s-tfstate", var.prefix)
  acl    = "private"

  # Allow deletion of non-empty bucket
  force_destroy = true

  # Unfortunately this feature isn't possible through a module, https://github.com/hashicorp/terraform/issues/27360
  # This actually was an issue as my S3 bucket was deleted by another TWer twice by accident as they were using the same bucket name
  #lifecycle {
  #  prevent_destroy = true
  #}

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
