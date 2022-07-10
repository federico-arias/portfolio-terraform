resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project}-terraform-state"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.18.0"
    }
  }

  backend "s3" {
    bucket  = "komettest-terraform-state" # "${var.project}-terraform-state"
    key     = "terraform.tfstate"
    region  = "us-east-2" # update with var.region
    profile = "komet"     # update with var.aws_profile
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
