data terraform_remote_state "common" {
  backend = "s3"

  config = {
    bucket         = "${var.project}-terraform-state"
    key            = "common/terraform.tfstate"
    region         = "${var.region}"
    profile        = "${var.aws_profile}"
  }
}
