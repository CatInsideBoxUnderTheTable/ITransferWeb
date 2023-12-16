data "aws_region" "current" {}

module "cost_monitoring" {
  source = "../../modules/costMonitoring"

  aws_region            = data.aws_region.current.name
  environment_name      = var.environment_name
  notification_receiver = var.email_notification_subscriber

  overall_spending_monitoring = {
    maxAllowedPriceInUsd = 20
  }
}
