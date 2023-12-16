output "app_secrets" {
  value = {
    login_secret_id    = aws_secretsmanager_secret.app_login.id
    password_secret_id = aws_secretsmanager_secret.app_password.id
  }

  sensitive = true
}

output "app_aws_secrets" {
  value = {
    login_secret_id    = aws_secretsmanager_secret.app_aws_console_login.id
    password_secret_id = aws_secretsmanager_secret.app_aws_console_password.id
  }

  sensitive = true
}

