locals {
  alb_alias_domain_name = "api.${var.dns.domain_name}"
}
resource "aws_route53_record" "alb_alias" {
  name    = local.alb_alias_domain_name
  zone_id = var.dns.domain_zone_id
  type    = "A"

  alias {
    name                   = aws_alb.public_alb.dns_name
    zone_id                = aws_alb.public_alb.zone_id
    evaluate_target_health = false
  }

}

module "acm" {
  source     = "terraform-aws-modules/acm/aws"
  version    = "~> 4.0"
  depends_on = [aws_route53_record.alb_alias]

  domain_name = local.alb_alias_domain_name
  zone_id     = var.dns.domain_zone_id

  validation_method   = "DNS"
  wait_for_validation = true
}
