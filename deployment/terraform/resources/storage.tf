resource "azurerm_storage_account" "osmseed" {
  name                     = "${local.storage}"
  resource_group_name      = azurerm_resource_group.osmseed.name
  location                 = azurerm_resource_group.osmseed.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "replication" {
  name                  = "replication"
  storage_account_name  = azurerm_storage_account.osmseed.name
  container_access_type = "private"
}