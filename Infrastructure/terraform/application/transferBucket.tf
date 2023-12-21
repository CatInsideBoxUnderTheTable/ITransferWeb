module "transfer_bucket" {
  source = "../modules/transferBucket"

  aws_region = data.aws_region.current.name

  bucket_object_lifetime = 3
  environment_name       = var.environment_name
  logging_bucket_name    = module.log_bucket.logs_bucket_name
}
