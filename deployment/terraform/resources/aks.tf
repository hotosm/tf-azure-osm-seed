resource "azurerm_kubernetes_cluster" "osmseed" {
  name                = "${local.prefix}-cluster"
  location            = azurerm_resource_group.osmseed.location
  resource_group_name = azurerm_resource_group.osmseed.name
  dns_prefix          = "${local.prefix}-cluster"
  kubernetes_version  = "1.20.13" #FIXME

  default_node_pool {    #FIXME
    name           = "nodepool1"
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks.id
    enable_auto_scaling   = true
    min_count             = 1
    max_count             = 8
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "AI4E"
  }
}


# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "network" {
  scope                = azurerm_resource_group.osmseed.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.osmseed.identity[0].principal_id
}
