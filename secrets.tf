# TODO
resource "aws_secretsmanager_secret" "db_password" {
  name = "POSTGRES_PWD"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}
