// terraform import cloudflare_record.test 7577fcd5eb9a1ca266cf9eaaf5f59c8a/6e5eb7f4325cf3e8c87e8ce899acd2be
resource "cloudflare_record" "www" {
  name            = "www"
  type            = "CNAME"
  value           = aws_lb.loadbalancer.dns_name
  ttl             = 3600
  zone_id         = "7577fcd5eb9a1ca266cf9eaaf5f59c8a"
  allow_overwrite = true
}

resource "cloudflare_record" "main" {
  name            = "@"
  type            = "CNAME"
  value           = aws_lb.loadbalancer.dns_name
  ttl             = 3600
  zone_id         = "7577fcd5eb9a1ca266cf9eaaf5f59c8a"
  allow_overwrite = true
}



// https://github.com/cloudflare/terraform-provider-cloudflare/issues/154
resource "cloudflare_record" "validation" {
  zone_id = "7577fcd5eb9a1ca266cf9eaaf5f59c8a"
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  value   = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value
}
