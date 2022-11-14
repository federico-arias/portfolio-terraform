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
  aws_lb_url = "k8s-kmtapp-backendi-aad346a96e-347144641.us-east-2.elb.amazonaws.com"
}
