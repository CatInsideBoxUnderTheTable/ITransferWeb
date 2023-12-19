locals {
  dns_name = "itransfer24.com"
}

// zone managed through AWS console
data "aws_route53_zone" "selected" {
  name         = local.dns_name
  private_zone = false
}
