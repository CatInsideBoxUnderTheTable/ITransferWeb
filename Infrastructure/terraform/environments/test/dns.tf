locals {
  domain_name = "itransfer24.com"
}

module "dns" {
  source = "../../modules/dns"

  domain_name = local.domain_name

  alb_alias_configs = {
    eu_config = {
      alias_name  = "api.${local.eu_region}.${local.domain_name}"
      dns_name    = module.eu_central_1_application.alb_dns.dns_name
      dns_zone_id = module.eu_central_1_application.alb_dns.dns_zone_id
    },
    us_config = {
      alias_name  = "api.${local.us_region}.${local.domain_name}"
      dns_name    = module.us_east_2_application.alb_dns.dns_name
      dns_zone_id = module.us_east_2_application.alb_dns.dns_zone_id
    }
  }

  alb_weighted_routing = {
    alias_name = "api.${local.domain_name}"
    config = {
      eu_config = {
        dns_name    = module.eu_central_1_application.alb_dns.dns_name
        dns_zone_id = module.eu_central_1_application.alb_dns.dns_zone_id
        weight      = 60
      },
      us_config = {
        dns_name    = module.us_east_2_application.alb_dns.dns_name
        dns_zone_id = module.us_east_2_application.alb_dns.dns_zone_id
        weight      = 40
      }
    }
  }
}
