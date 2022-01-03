# TODO
resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.project}-db-password"
}

resource "aws_secretsmanager_secret_version" "current" {
  secret_id     = aws_secretsmanager_secret.db_password.id
}

# aws_secretsmanager_secret_version.current.secret_string
