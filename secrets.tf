resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.project}-rds-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.database.result
}
