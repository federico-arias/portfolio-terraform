// terraform import cloudflare_record.main 7577fcd5eb9a1ca266cf9eaaf5f59c8a/6e5eb7f4325cf3e8c87e8ce899acd2be
resource "cloudflare_record" "www" {
  name  = var.subdomain
  type  = "CNAME"
  value = "a9567cb26c66746a39f9f87454dd7e8f-1813436565.us-east-2.elb.amazonaws.com"
  # aws_lb.loadbalancer.dns_name
  ttl             = 3600
  zone_id         = "7577fcd5eb9a1ca266cf9eaaf5f59c8a"
  allow_overwrite = true
}

/*
resource "cloudflare_record" "main" {
  count           = var.subdomain == "www" ? 1 : 0
  name            = "@"
  type            = "CNAME"
  value           = aws_lb.loadbalancer.dns_name
  ttl             = 3600
  zone_id         = "7577fcd5eb9a1ca266cf9eaaf5f59c8a"
  allow_overwrite = true
}
*/
