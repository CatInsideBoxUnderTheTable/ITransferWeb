variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "environment_name" {
  type    = string
  default = "testenv"
}

variable "default_tags" {
  type = map(string)
  default = {
    Owner       = "CatInsideBoxUnderTheTable"
    Environment = "TestEnv"
    ManagedBy   = "Terraform"
  }
}

variable "subnets_azs" {
  type        = list(string)
  description = "Public availability zones where networks should be spawned"
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "email_notification_subscriber" {
  type    = string
  default = "kocham@kotki.pl"
}

