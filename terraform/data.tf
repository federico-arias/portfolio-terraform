data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    #bucket  = "${var.project}-terraform-state"
    bucket  = "komet-terraform-state"
    key     = "common/terraform.tfstate"
    region  = "us-east-2" #"${var.common_state_aws_region}"
    profile = "${var.aws_profile}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
