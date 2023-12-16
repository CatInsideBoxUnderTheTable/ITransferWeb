module "iam" {
  source = "../modules/iam"

  aws_region                         = data.aws_region.current.name
  environment_name                   = var.environment_name
  bucket_console_users               = ["default-${var.environment_name}"]
  transfer_bucket_arn                = module.transfer_bucket.transfer_bucket_arn
  transfer_bucket_encryption_key_arn = module.transfer_bucket.transfer_bucket_encryption_key_arn
}
