include "common" {
  path = find_in_parent_folders()
  expose = true
}

inputs = {
  environment = "staging"
  aws_region = "us-east-1"
  subdomain = "staging"
}
