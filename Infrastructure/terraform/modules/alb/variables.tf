variable "solution_name" {
  type        = string
  description = "Allows to identify whole solution. Keep meaningfull name"
}

variable "vpc" {
  type = object({
    id         = string
    cidr_block = string //10.0.0.0 /16
  })
}

variable "logging_bucket_name" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "public_subnets_ids" {
  type = list(string)
}

variable "forward_traffic_to_port" {
  type = string
}

variable "dns" {
  type = object({
    domain_name    = string
    domain_zone_id = string
  })
}

variable "target_group_health_heck" {
  type = object({
    interval                          = number
    check_timeout                     = number
    min_failures_to_mark_as_unhealthy = number
    min_successes_to_mark_as_healthy  = number
  })

}
