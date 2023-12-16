data "aws_secretsmanager_secret_version" "app_login" {
  secret_id = var.secrets.login_secret_id
}

data "aws_secretsmanager_secret_version" "app_password" {
  secret_id = var.secrets.password_secret_id
}

data "aws_secretsmanager_secret_version" "console_login" {
  secret_id = var.secrets.console_login_secret_id
}
data "aws_secretsmanager_secret_version" "console_password" {
  secret_id = var.secrets.console_password_secret_id
}
