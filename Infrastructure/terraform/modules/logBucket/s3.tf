//todo: add additional encryption for bucket
resource "aws_s3_bucket" "logs_bucket" {
  bucket        = "common-security-logging-bucket-${var.environment_name}"
  force_destroy = true
}

data "aws_iam_policy_document" "storage_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:ListBucket", "s3:GetObject"]
    resources = ["${aws_s3_bucket.logs_bucket.arn}/*", aws_s3_bucket.logs_bucket.arn]

    principals {
      identifiers = var.privileged_aws_prinipals_arns
      type        = "AWS"
    }
    principals {
      identifiers = var.privileged_service_prinipals_arns
      type        = "Service"
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_storage_policy" {
  bucket = aws_s3_bucket.logs_bucket.id
  policy = data.aws_iam_policy_document.storage_policy.json
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.logs_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # AWS LIMIT: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html
    }
  }
}
