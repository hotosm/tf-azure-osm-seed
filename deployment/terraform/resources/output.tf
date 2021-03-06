output "environment" {
  value = var.environment
}

output "location" {
  value = local.location
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.osmseed.name
}

output "resource_group" {
  value = azurerm_resource_group.osmseed.name
}

output "storage_connection_string" {
  value = azurerm_storage_account.osmseed.primary_connection_string
}

output "osmseed_db_disk_name" {
  value = azurerm_managed_disk.osmseed_db.name
}

output "osmseed_db_disk_id" {
  value = azurerm_managed_disk.osmseed_db.id
}