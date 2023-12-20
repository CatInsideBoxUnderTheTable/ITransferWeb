//todos: add kms encryption for each password secret

resource "aws_secretsmanager_secret" "app_login" {
  name = "api-app-login"
}

resource "aws_secretsmanager_secret" "app_password" {
  name = "api-app-password"
}

resource "aws_secretsmanager_secret" "app_aws_console_login" {
  name = "app-aws-console-login"
}

resource "aws_secretsmanager_secret" "app_aws_console_password" {
  name = "app-aws-console-password"
}
