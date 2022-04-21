/*
resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.project}-db_password"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
}

resource "aws_secretsmanager_secret_version" "db_username_current" {
  secret_id  = aws_secretsmanager_secret.db_username.id
}
*/
