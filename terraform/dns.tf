resource "aws_route53_zone" "main" {
  name = var.domain

  tags = {
    Environment = var.environment
  }
}

/*
resource "aws_route53_record" "dev-ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "dev.komet.social"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.dev.name_servers
}
*/
