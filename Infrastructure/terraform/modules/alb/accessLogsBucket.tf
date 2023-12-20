data "aws_elb_service_account" "this" {}

//todo: add additional encryption for bucket
resource "aws_s3_bucket" "alb_access_logs_bucket" {
  bucket        = local.alb_name
  force_destroy = true
}

data "aws_iam_policy_document" "storage_policy" {

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:ListBucket", "s3:GetObject"]
    resources = ["${aws_s3_bucket.alb_access_logs_bucket.arn}/*", aws_s3_bucket.alb_access_logs_bucket.arn]

    principals {
      identifiers = [data.aws_elb_service_account.this.arn]
      type        = "AWS"
    }

  }
}

resource "aws_s3_bucket_policy" "bucket_storage_policy" {
  bucket = aws_s3_bucket.alb_access_logs_bucket.id
  policy = data.aws_iam_policy_document.storage_policy.json
}
