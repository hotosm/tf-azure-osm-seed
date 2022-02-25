resource "azurerm_public_ip" "osmseed" {
  name                = "${local.prefix}PublicIP"
  resource_group_name = azurerm_resource_group.osmseed.name
  location            = azurerm_resource_group.osmseed.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
  }
}