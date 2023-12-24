locals {
  solution_name = "itransfer-api"
  api_port      = 9000
}

module "publicAlb" {
  source     = "../modules/alb"
  depends_on = [module.log_bucket]

  solution_name    = local.solution_name
  environment_name = var.environment_name

  forward_traffic_to_port = local.api_port
  public_subnets_ids      = module.vpc.public_subnets_ids

  logging_bucket_name = module.log_bucket.logs_bucket_name

  vpc = {
    id         = module.vpc.vpc_id
    cidr_block = module.vpc.vpc_cidr_block
  }

  target_group_health_heck = {
    interval                          = 100 // check health each XX seconds
    check_timeout                     = 5   // if no response received through XX second then fail
    min_successes_to_mark_as_healthy  = 2
    min_failures_to_mark_as_unhealthy = 3
  }

  dns = {
    domain_name    = var.dns_config.domain_name
    domain_zone_id = var.dns_config.dns_zone_id
  }
}
