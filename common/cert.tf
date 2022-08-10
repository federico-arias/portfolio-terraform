# this should be validated only once
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn
  //validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
  validation_record_fqdns = ["${cloudflare_record.validation.hostname}"]
}

// https://github.com/cloudflare/terraform-provider-cloudflare/issues/154
resource "cloudflare_record" "validation" {
  zone_id = "7577fcd5eb9a1ca266cf9eaaf5f59c8a"
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  value   = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value
}
