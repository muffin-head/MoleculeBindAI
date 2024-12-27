# Output for Resource Group
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
  description = "Name of the resource group"
}

# Output for Storage Account
output "storage_account_name" {
  value = azurerm_storage_account.datalake.name
  description = "Name of the storage account (ADLS Gen2)"
}

output "storage_account_id" {
  value = azurerm_storage_account.datalake.id
  description = "Resource ID of the storage account"
}
# Outputs for Storage Containers
output "bronze_container_url" {
  value = azurerm_storage_container.bronze.id
  description = "Resource ID of the Bronze container"
}

# Output for Synapse Workspace
output "synapse_workspace_name" {
  value = azurerm_synapse_workspace.workspace.name
  description = "Name of the Synapse Analytics workspace"
}
output "synapse_workspace_id" {
  value = azurerm_synapse_workspace.workspace.id
  description = "Resource ID of the Synapse Analytics workspace"
}
output "spark_pool_name" {
  value = azurerm_synapse_spark_pool.spark_pool.name
  description = "Name of the Spark pool in the Synapse workspace"
}
