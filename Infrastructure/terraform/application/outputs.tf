output "alb_dns" {
  value = {
    dns_name    = module.public_alb.alb_dns.dns_name
    dns_zone_id = module.public_alb.alb_dns.dns_zone_id
  }
}
