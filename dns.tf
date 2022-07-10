resource "aws_route53_zone" "main" {
  name = "komet.social"
}

resource "aws_route53_zone" "dev" {
  name = "dev.komet.social"

  tags = {
    Environment = "dev"
  }
}

resource "aws_route53_record" "dev-ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "dev.komet.social"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.dev.name_servers
}
