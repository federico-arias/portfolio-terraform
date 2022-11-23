include "common" {
  path = find_in_parent_folders()
  expose = true
}

inputs = {
  environment = "staging"
  aws_region = "us-east-1"
  subdomain = "staging"
  aws_lb_url = "k8s-kmtapp-backendi-a0b82c22fb-756436366.us-east-1.elb.amazonaws.com"
}
