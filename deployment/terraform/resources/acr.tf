data "azurerm_container_registry" "osmseed" {
  name                = var.osmseed_test_resources_acr #FIXME
  resource_group_name = var.osmseed_test_resources_rg #FIXME
}

# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "attach_acr" {
  scope                = data.azurerm_container_registry.osmseed.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.osmseed.kubelet_identity[0].object_id
}
