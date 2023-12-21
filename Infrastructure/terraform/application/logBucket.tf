data "aws_elb_service_account" "this" {}

module "log_bucket" {
  source = "../modules/logBucket"

  environment_name                  = var.environment_name
  privileged_aws_prinipals_arns     = [data.aws_elb_service_account.this.arn]
  privileged_service_prinipals_arns = ["delivery.logs.amazonaws.com"]
}
