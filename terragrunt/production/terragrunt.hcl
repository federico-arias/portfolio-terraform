terraform {
  source = "../../terraform"
}

inputs = {
  account_id = "135541436944"
  aws_profile = "komet"
  region = "us-east-2"
  project = "komettest"
  backend_tag = "v1.9.1"
  frontend_tag = "v1.9.1"
  landing_tag = "v1.0.2"
  domain = "komet.social"
}
