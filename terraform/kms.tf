# TODO: use this for the bastion key instead of the one generated manually
resource "aws_kms_key" "bastion_key" {
  description              = "${local.project}-bastion-key"
  customer_master_key_spec = "RSA_4096"
}

resource "aws_kms_key" "sops" {
  description             = "Project ${local.project}'s key for SOPS"
  deletion_window_in_days = 30
}
