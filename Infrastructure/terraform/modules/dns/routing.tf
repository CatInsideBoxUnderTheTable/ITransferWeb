locals {
  dns_name = "itransfer24.com"
}

data "aws_region" "current" {}

// zone managed through AWS console
data "aws_route53_zone" "selected" {
  name         = local.dns_name
  private_zone = false
}

resource "aws_route53_record" "alb_alias" {
  for_each = var.alb_alias_configs

  name    = each.value.alias_name
  zone_id = data.aws_route53_zone.selected.id
  type    = "A"


  alias {
    name                   = each.value.dns_name
    zone_id                = each.value.dns_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "alb_weighted_routing" {
  for_each = var.alb_weighted_routing.config

  name    = var.alb_weighted_routing.alias_name
  zone_id = data.aws_route53_zone.selected.id
  type    = "CNAME"
  ttl     = 60

  set_identifier = each.key
  records        = [each.value.dns_name]

  weighted_routing_policy {
    weight = each.value.weight
  }
}

