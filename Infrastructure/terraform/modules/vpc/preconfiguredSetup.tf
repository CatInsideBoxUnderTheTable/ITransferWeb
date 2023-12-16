module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_identifier
  cidr = var.vpc_cidr

  azs             = var.subnets_azs
  private_subnets = var.private_subnets_cidrs
  public_subnets  = var.public_subnets_cidrs

  enable_flow_log           = true
  flow_log_destination_arn  = var.logging_bucket_arn
  flow_log_destination_type = "s3"

  enable_nat_gateway = true
  enable_vpn_gateway = false
}
