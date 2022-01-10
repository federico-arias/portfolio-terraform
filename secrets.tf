# TODO
resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.project}-db-password"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = aws_secretsmanager_secret.db_password.id
}

/*
resource "aws_secretsmanager_secret" "db_username" {
  name = "${var.project}-db-username"
}

resource "aws_secretsmanager_secret_version" "db_username_current" {
  secret_id  = aws_secretsmanager_secret.db_username.id
}
*/
