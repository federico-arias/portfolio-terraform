locals {
  backend_container_name  = "${var.project}-${var.environment}-backend-container"
  frontend_container_name = "${var.project}-${var.environment}-frontend-container"
  landing_container_name  = "${var.project}-${var.environment}-landing-container"
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project}-${var.environment}-ecs"
}

resource "aws_security_group" "ecs" {
  name   = "${var.project}-${var.environment}-ecs-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
