variable "aws_region" {
  type = string
}

variable "solution_name" {
  type        = string
  description = "Allows to identify whole solution. Keep meaningfull name"
}

variable "network_config" {
  type = object({
    security_groups_ids = list(string)
    subnets_ids         = list(string)
  })
}

variable "environment_name" {
  type = string
}

variable "ecs_scaling" {
  type = object({
    desired_count = number
  })
}

variable "load_balancing" {
  type = object({
    alb_target_group_arn = string
    container_name       = string
    container_port       = string
    application_port     = string
  })
}
