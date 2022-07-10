resource "aws_acm_certificate" "cert" {
  domain_name       = "komet.social"
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn
  //validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
  validation_record_fqdns = ["${cloudflare_record.validation.hostname}"]
}

resource "aws_lb_listener_certificate" "backend_certificate" {
  certificate_arn = aws_acm_certificate.cert.arn
  listener_arn    = aws_lb_listener.loadbalancer_listener.arn
}
