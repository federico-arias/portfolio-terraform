terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.18.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = "/home/federico/.aws/credentials"
  profile                 = var.aws_profile

}

provider "cloudflare" {
  email     = "contacto@komet.social"
  api_token = "4XOBBHEDZC-mSFyX2jqT5fEQUI4BEdoY1lDdOCjk"
}
