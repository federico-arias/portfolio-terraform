terraform {
  source = "../..//terraform"
}

locals {
  project = "komet"
  region = "us-east-2"
  aws_profile = "komet"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "${local.project}-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.region}"
    encrypt        = true
    profile        = "${local.aws_profile}"
  }
}
EOF
}

inputs = {
  account_id = "135541436944"
  aws_profile = local.aws_profile
  region = local.region
  domain = "komet.social"
  project = local.project
}
