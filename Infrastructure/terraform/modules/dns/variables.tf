variable "domain_name" {
  type = string
}

variable "alb_alias_configs" {
  type = map(object({
    alias_name  = string
    dns_name    = string
    dns_zone_id = string
  }))
}

variable "alb_weighted_routing" {
  type = object({
    alias_name = string
    config = map(object({
      dns_name    = string
      dns_zone_id = string
      weight      = number
    }))
  })
}
