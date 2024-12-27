# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "moleculebindai-rg"
  location = var.location
}

# Storage Account (ADLS Gen2)
resource "azurerm_storage_account" "datalake" {
  name                     = "moleculebindaidatalake"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
  tags = {
    environment = "dev"
  }
}

# Storage Container
resource "azurerm_storage_container" "bronze" {
  name                  = "bronze"
  storage_account_id    = azurerm_storage_account.datalake.id
  container_access_type = "private"
}

# Synapse Workspace
resource "azurerm_synapse_workspace" "workspace" {
  name                             = "synapse-workspace-moleculebindai"  # Ensure uniqueness
  resource_group_name              = azurerm_resource_group.rg.name
  location                         = "westus"  # Updated region to a supported location
  storage_data_lake_gen2_filesystem_id = "https://${azurerm_storage_account.datalake.name}.dfs.core.windows.net/bronze"  # Corrected URL format
  sql_administrator_login          = "adminuser"
  sql_administrator_login_password = "SecurePassword123!"

  identity {
    type = "SystemAssigned"  # Added required SystemAssigned identity
  }

  tags = {
    environment = "dev"
  }
}

# Synapse Spark Pool
resource "azurerm_synapse_spark_pool" "spark_pool" {
  name                 = "sparkpool01"
  synapse_workspace_id = azurerm_synapse_workspace.workspace.id

  spark_version    = "3.3"               # Specify the Spark version
  node_size        = "Small"            # Node size: Small, Medium, or Large
  node_size_family = "MemoryOptimized"  # Required attribute
  node_count       = 3                  # Fixed number of nodes (no autoscaling)

  tags = {
    environment = "dev"
  }
}
