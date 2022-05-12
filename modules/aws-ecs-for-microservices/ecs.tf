resource "aws_ecs_task_definition" "backend" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  task_role_arn      = var.task_role_arn
  execution_role_arn = var.task_execution_role_arn

  container_definitions = jsonencode([
    {
      "image"       = "${aws_ecr_repository.repository.repository_url}:${var.tag}"
      "cpu"         = 1024
      "memory"      = 2048
      "name"        = local.backend_container_name
      "networkMode" = "awsvpc"
      "environment" = var.environment_variables
      "logConfiguration" = {
        "logDriver" = "awslogs"
        "options" = {
          "awslogs-group"         = var.project
          "awslogs-region"        = var.region
          "awslogs-create-group"  = "true"
          "awslogs-stream-prefix" = local.backend_container_name
        }
      }
      "portMappings" = [
        {
          "containerPort" = 80
          "hostPort"      = 80
        }
      ]
  }])
}

resource "aws_ecs_service" "backend" {
  name                              = "${var.project}-backend"
  cluster                           = var.ecs_cluster
  task_definition                   = var.task_definition_arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 120
  force_new_deployment              = true

  network_configuration {
    security_groups = [module.app_security_group.security_group_id, aws_security_group.ecs.id]
    subnets         = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.id
    container_name   = local.backend_container_name
    container_port   = 80
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = false
  }

  depends_on = [aws_lb_listener.loadbalancer_listener, module.app_security_group]
}
