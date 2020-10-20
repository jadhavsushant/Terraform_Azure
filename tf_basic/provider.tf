provider "azurerm" {
  version = "=1.44.0"

  subscription_id = var.sub_id
  client_id = "${var.cli_id}"
  client_secret = "${var.cli_sec}"
  tenant_id = "${var.ten_id}"
}