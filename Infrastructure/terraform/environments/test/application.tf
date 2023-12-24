module "application" {
  source = "../../application"

  email_notification_subscriber = var.email_notification_subscriber
  environment_name              = var.environment_name
  subnets_azs                   = var.subnets_azs

  dns_config = {
    domain_name = module.dns.domain_name
    dns_zone_id = module.dns.domain_zone_id
  }
}
