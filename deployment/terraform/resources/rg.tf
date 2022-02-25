resource "azurerm_resource_group" "osmseed" {
  name     = "${local.prefix}_rg"
  location = var.region
}