output "transfer_bucket_arn" {
  value = aws_s3_bucket.transfer_bucket.arn
}

output "transfer_bucket_encryption_key_arn" {
  value = aws_kms_key.transfer_bucket_encryption_key.arn
}

output "transfer_bucket_name" {
  value = aws_s3_bucket.transfer_bucket.id
}

output "transfer_bucket_region" {
  value = aws_s3_bucket.transfer_bucket.region
}
