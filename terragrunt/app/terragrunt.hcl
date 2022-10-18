include "common" {
  path = find_in_parent_folders()
  expose = true
}

inputs = {
  environment = "production"
  aws_region = "us-east-2"
  backend_tag = "v1.9.1"
  frontend_tag = "v1.9.1"
  landing_tag = "v1.0.2"
  subdomain = "app"
}
