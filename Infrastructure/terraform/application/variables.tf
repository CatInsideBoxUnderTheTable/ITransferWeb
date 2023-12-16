variable "environment_name" {
  type = string
}

variable "email_notification_subscriber" {
  type = string
}

variable "subnets_azs" {
  type        = list(string)
  description = "Public availability zones where networks should be spawned"
}

variable "dns_config" {
  type = object({
    domain_name = string
    dns_zone_id = string
  })
}
