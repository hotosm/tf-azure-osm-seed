resource "azurerm_virtual_network" "osmseed-cluster" {
  name                = "${local.prefix}-cluster-network"
  location            = azurerm_resource_group.osmseed.location
  resource_group_name = azurerm_resource_group.osmseed.name
  address_space       = ["10.0.0.0/8"]
}

# subnet for node pools
resource "azurerm_subnet" "aks" {
  name                 = "${local.prefix}-aks-subnet"
  virtual_network_name = azurerm_virtual_network.osmseed-cluster.name
  resource_group_name  = azurerm_resource_group.osmseed.name
  address_prefixes     = ["10.1.0.0/16"]
}
