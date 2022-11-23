/*
module "certificate" {
  source                  = "./terraform-aws-acm-certificate"
  domain_name             = "*.${var.domain}"
  for_each                = var.aws_regions
  aws_region              = each.value
  validation_record_fqdns = ["${cloudflare_record.validation.hostname}"]
}
*/

module "certificate" {
  source      = "./terraform-aws-acm-certificate"
  domain_name = "app.${var.domain}"
  aws_region  = "us-east-2"
}

module "certificate_east_1" {
  source      = "./terraform-aws-acm-certificate"
  domain_name = "staging.${var.domain}"
  aws_region  = "us-east-1"
}
