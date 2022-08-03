# ECS services point to target groups and a target group is referenced by a listener rule

resource "aws_lb_listener_rule" "listener_rule" {
  # listener_arn = aws_lb_listener.loadbalancer_listener.arn
   listener_arn = var.loadbalancer_listener_arn
  # priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    path_pattern {
      values = var.path_pattern
    }
  }
}


resource "aws_lb_target_group" "target_group" {
  name        = "${var.name}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    port     = 80
    protocol = "HTTP"
    path     = var.healthcheck_path
  }

  # See https://stackoverflow.com/a/60080801/1797161
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}
