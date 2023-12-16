module "eu_central_1_application" {
  source = "../../application"

  providers = {
    aws = aws
  }

  email_notification_subscriber = var.email_notification_subscriber
  environment_name              = "${var.environment_name}-eu"
  subnets_azs                   = ["eu-central-1a", "eu-central-1b"]

  dns_config = {
    domain_name = module.dns.domain_name
    dns_zone_id = module.dns.domain_zone_id
  }
}

module "us_east_2_application" {
  source = "../../application"

  providers = {
    aws = aws.us
  }

  email_notification_subscriber = var.email_notification_subscriber
  environment_name              = "${var.environment_name}-us"
  subnets_azs                   = ["us-east-2a", "us-east-2b"]

  dns_config = {
    domain_name = module.dns.domain_name
    dns_zone_id = module.dns.domain_zone_id
  }
}
