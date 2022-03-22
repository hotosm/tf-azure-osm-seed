resource "azurerm_managed_disk" "osmseed_db" {
  name                 = "${local.prefix}-db"
  location            = azurerm_resource_group.osmseed.location
  resource_group_name = azurerm_kubernetes_cluster.osmseed.node_resource_group
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.osmseed_db_disk_size

  tags = {
    Environment = var.environment
    ManagedBy   = local.owner
  }
}


resource "azurerm_role_assignment" "attach_disk" {
  scope                = resource.azurerm_resource_group.osmseed.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.osmseed.kubelet_identity[0].object_id
}