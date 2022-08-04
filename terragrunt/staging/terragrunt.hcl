include "common" {
  path = find_in_parent_folders()
  expose = true
}

locals {
  environment = "staging"
  project = "komet"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "${local.project}-terraform-state"
    key            = "${local.environment}/terraform.tfstate"
    region         = "${include.common.inputs.region}"
    encrypt        = true
    profile        = "${include.common.inputs.aws_profile}"
  }
}
EOF
}

inputs = {
  project = local.project
  environment = local.environment
  backend_tag = "v1.9.1"
  frontend_tag = "v1.9.1"
  landing_tag = "v1.0.2"
  subdomain = "staging"
}
