variable "environment_name" {
  type = string
}

variable "privileged_aws_prinipals_arns" {
  type = list(string)
}

variable "privileged_service_prinipals_arns" {
  type = list(string)
}
