resource "random_string" "random_string" {
  length  = 16
  special = false
  upper   = false
  lower   = true
  numeric = true

  override_special = "_-"
}
