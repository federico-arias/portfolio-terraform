resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform"
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
  }

/*
  backend "s3" {
    bucket = "terraform"
    key    = "testing" # var.project
    region = "us-east-2" # var.region
  }
*/

  required_version = "~> 1.0"
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = "/home/federico/.aws/credentials"
  profile                 = "komet"
}
