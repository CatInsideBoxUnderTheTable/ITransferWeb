locals {
  eu_region = "eu-central-1"
  us_region = "us-east-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      region = "eu-central-1"
      env    = "test"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  alias  = "us"

  default_tags {
    tags = {
      region = "eu-central-1"
      env    = "test"
    }
  }
}

