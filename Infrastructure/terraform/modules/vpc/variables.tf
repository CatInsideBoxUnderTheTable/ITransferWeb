variable "vpc_cidr" {
  type        = string
  description = "Whole VPC subnet CIDR block"
}

variable "vpc_identifier" {
  type = string

}

// proposed "10.0.1.0/24", "10.0.2.0/24"
variable "public_subnets_cidrs" {
  type        = list(string)
  description = "Public subnets, created based on count"
}

// proposed "10.0.10.0/24", "10.0.11.0/24"
variable "private_subnets_cidrs" {
  type        = list(string)
  description = "Public subnets, created based on count"
}

// "eu-central-1a", "eu-central-1b"
variable "subnets_azs" {
  type        = list(string)
  description = "Public availability zones where networks should be spawned"
}
