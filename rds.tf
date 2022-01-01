resource "aws_db_subnet_group" "main_db" {
  name       = "${var.project}-db-subnet"
  subnet_ids = module.vpc.private_subnets

}

resource "aws_security_group" "main_db" {
  name   = var.project
  vpc_id = module.vpc.vpc_id

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
  name   = var.project
  family = "postgres12"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "main" {
  identifier             = "${var.project}-main"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "12.8"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main_db.name
  vpc_security_group_ids = [aws_security_group.main_db.id]
  parameter_group_name   = aws_db_parameter_group.main_db.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}
