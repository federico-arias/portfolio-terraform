terraform {
  source = "../..//common"
}

inputs = {
  aws_region = "us-east-2"
}

include "shared" {
  path = find_in_parent_folders()
}
