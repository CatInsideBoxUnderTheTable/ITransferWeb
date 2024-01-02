module "vpc" {
  source     = "../modules/vpc"
  depends_on = [module.log_bucket]

  vpc_identifier = var.environment_name

  vpc_cidr              = "10.0.0.0/16"
  public_subnets_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  subnets_azs           = var.subnets_azs
  logging_bucket_arn    = module.log_bucket.logs_bucket_arn
}
