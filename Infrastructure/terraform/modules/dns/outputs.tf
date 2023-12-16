output "domain_name" {
  value = local.dns_name
}
output "domain_zone_id" {
  value = data.aws_route53_zone.selected.id
}
