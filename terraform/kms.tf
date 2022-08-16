# TODO: use this for the bastion key instead of the one generated manually
resource "aws_kms_key" "bastion_key" {
  description              = "${var.project}-${var.environment}-bastion-key"
  customer_master_key_spec = "RSA_4096"
}
