output "logs_bucket_arn" {
  value = aws_s3_bucket.logs_bucket.arn
}

# output "logs_bucket_encryption_key_arn" {
#   value = aws_kms_key.transfer_bucket_encryption_key.arn
# }

output "logs_bucket_name" {
  value = aws_s3_bucket.logs_bucket.id
}
