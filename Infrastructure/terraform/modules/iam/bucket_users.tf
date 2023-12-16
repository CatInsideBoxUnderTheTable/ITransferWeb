locals {
  formatted_names = [for v in var.bucket_console_users : format("bucket-user-%s", v)]
}

resource "aws_iam_user" "bucket_users" {
  for_each = toset(local.formatted_names)

  name = each.value
  path = "/users/uploaders/"
}

resource "aws_iam_user_policy_attachment" "bucket_uploaders_policy_attachment" {
  for_each = aws_iam_user.bucket_users

  user       = each.key
  policy_arn = aws_iam_policy.bucket_user_actions_policy.arn
}

resource "aws_iam_policy" "bucket_user_actions_policy" {
  name        = "bucket-upload-policy-${var.environment_name}"
  policy      = data.aws_iam_policy_document.bucket_user_policy.json
  description = "allows for access to ITransfer upload bucket"
}

data "aws_iam_policy_document" "bucket_user_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = [format("%s/*", var.transfer_bucket_arn)]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:Encrypt", "kms:GenerateDataKey"]
    resources = [var.transfer_bucket_encryption_key_arn]
  }
}
