
resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.project}-${var.environment}-backend-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      "image"       = "${aws_ecr_repository.backend.repository_url}:${var.backend_tag}"
      "cpu"         = 1024
      "memory"      = 2048
      "name"        = local.backend_container_name
      "networkMode" = "awsvpc"
      "environment" = [
        {
          "name"  = "PORT"
          "value" = "80"
        },
        {
          "name"  = "DATABASE_URL"
          "value" = local.database_connection_string
        },
        {
          "name"  = "ROUTER_PATH"
          "value" = var.api_path
        },
        {
          "name"  = "VERSION"
          "value" = var.backend_tag
        },
        {
          "name"  = "BASE_URL"
          "value" = "https://${var.subdomain}.${var.domain}"
        }
      ]
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

  tags = merge(
    local.default_tags,
    {
      Status = "to_deprecate"
    },
  )
}

resource "aws_ecs_service" "backend" {
  name                              = "${var.project}-${var.environment}-backend"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.backend.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 120
  force_new_deployment              = true

  network_configuration {
    security_groups = [module.app_security_group.security_group_id, aws_security_group.ecs.id]
    subnets         = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.id
    container_name   = local.backend_container_name
    container_port   = 80
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = false
  }

  depends_on = [aws_lb_listener.loadbalancer_listener, module.app_security_group]
}
