resource "random_pet" "db_password" {
  #keepers = {
  # Generate a new pet name each time we switch to a new database
  #secret_arn = aws_secretsmanager_secret
  #  }
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.project}-${var.environment}-rds-password-${random_pet.db_password.id}"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.database.result
}
