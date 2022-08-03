# SSL config for load balancer
#
#
/*
  listener

  certificate_arn   = aws_acm_certificate.cert.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"



  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.landing.arn
  }
  */
