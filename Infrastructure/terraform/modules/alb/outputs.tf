output "api_alb_target_group_arn" {
  value = aws_alb_target_group.api_target_group.arn
}

output "api_alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_dns" {
  value = {
    dns_name    = aws_alb.public_alb.dns_name
    dns_zone_id = aws_alb.public_alb.zone_id
  }
}
