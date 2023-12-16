locals {
  alb_alias_domain_name = "api.${var.dns.domain_name}"
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = local.alb_alias_domain_name
  zone_id     = var.dns.domain_zone_id

  validation_method   = "DNS"
  wait_for_validation = true
}
