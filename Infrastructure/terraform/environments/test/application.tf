module "application" {
  source = "../../application"

  email_notification_subscriber = var.email_notification_subscriber
  environment_name              = var.environment_name
  subnets_azs                   = var.subnets_azs
}
