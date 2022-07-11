resource "aws_lb" "loadbalancer" {
  name               = "${var.project}-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [module.lb_security_group.this_security_group_id]

}

resource "aws_lb_listener" "loadbalancer_listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.landing.arn
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.loadbalancer_listener.arn
  # priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    path_pattern {
      values = ["${var.api_path}/*"]
    }
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.loadbalancer_listener.arn
  # priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    path_pattern {
      values = ["/app/*"]
    }
  }
}


#### TARGET GROUPS ####

# ECS services point to these target groups.

resource "aws_lb_target_group" "frontend" {
  name        = "${var.project}-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    port     = 80
    protocol = "HTTP"
    path     = "/"
  }

  # See https://stackoverflow.com/a/60080801/1797161
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_lb_target_group" "backend" {
  name        = "${var.project}-backend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  # we need to make this explicit. Otherwise, the ECS task blocks the port. The security
  # groups have no way of knowing the default `traffic-port`
  health_check {
    port     = 80
    protocol = "HTTP"
    path     = "${var.api_path}/healthz"
  }

  # See https://stackoverflow.com/a/60080801/1797161
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_lb_target_group" "landing" {
  name        = "${var.project}-landing-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  # we need to make this explicit. Otherwise, the ECS task blocks the port. The security
  # groups have no way of knowing the default `traffic-port`
  health_check {
    port     = 80
    protocol = "HTTP"
    path     = "/"
  }

  # See https://stackoverflow.com/a/60080801/1797161
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}
