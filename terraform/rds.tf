locals {
  database_connection_string = "postgres://${aws_db_instance.main.username}:${urlencode(random_password.database.result)}@${aws_db_instance.main.address}:5432/postgres"
}

resource "aws_db_subnet_group" "main_db" {
  name       = local.project
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}

resource "random_pet" "database" {
  #keepers = {
  # Generate a new pet name each time we switch to a new AMI id
  # ami_id = var.ami_id
  #}
  separator = "_"
}

resource "random_password" "database" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "aws_security_group" "main_db" {
  name   = local.project
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_db_parameter_group" "main_db" {
  name   = local.project
  family = "postgres12"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "main" {
  identifier             = local.project
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "12.8"
  username               = random_pet.database.id
  password               = random_password.database.result
  db_subnet_group_name   = aws_db_subnet_group.main_db.name
  vpc_security_group_ids = [aws_security_group.main_db.id]
  parameter_group_name   = aws_db_parameter_group.main_db.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}
