resource "aws_kms_key" "sops" {
  description             = "Project ${var.project}'s key for SOPS"
  deletion_window_in_days = 30
}
