resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.project}-${var.environment}-frontend-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      "image"       = "${data.terraform_remote_state.common.outputs.frontend_repo}:${var.frontend_tag}"
      "cpu"         = 1024
      "memory"      = 2048
      "name"        = local.frontend_container_name
      "networkMode" = "awsvpc"
      "environment" = [
        {
          "name"  = "PORT",
          "value" = "80"
        }
      ]
      "logConfiguration" = {
        "logDriver" = "awslogs"
        "options" = {
          "awslogs-group"         = var.project
          "awslogs-region"        = var.region
          "awslogs-create-group"  = "true"
          "awslogs-stream-prefix" = local.frontend_container_name
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

resource "aws_ecs_service" "frontend" {
  name            = "${var.project}-${var.environment}-frontend"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  health_check_grace_period_seconds = 120
  force_new_deployment              = true

  network_configuration {
    security_groups = [module.app_security_group.security_group_id]
    subnets         = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.id
    container_name   = local.frontend_container_name
    container_port   = 80
  }

  depends_on = [aws_lb_listener.loadbalancer_listener, module.app_security_group]
}
