# Storage Account
resource "azurerm_storage_account" "this" {
  name                     = var.sa_info.name
  resource_group_name      = var.sa_info.resource_group_name
  location                 = var.sa_info.resource_group_location
  account_tier             = var.sa_info.account_tier
  account_kind             = var.sa_info.account_kind
  account_replication_type = var.sa_info.account_replication_type
  is_hns_enabled           = var.sa_info.is_hns_enabled

  network_rules {
    default_action             = var.firewall_defautl_action
    ip_rules                   = var.allowed_ips
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }

  tags = var.tags
}

# Containers (for Storage Account)
resource "azurerm_storage_container" "this" {
  for_each              = var.sa_info.containers
  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = each.value.access_type
}

# Filesystems and Paths (for Data Lake Storage Gen 2)
resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  for_each           = var.sa_info.filesystems
  name               = each.value.name
  storage_account_id = azurerm_storage_account.this.id

  properties = {
  }
}

resource "azurerm_storage_data_lake_gen2_path" "this" {
  for_each           = var.sa_info.paths
  path               = each.value.name
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.this[each.value.fs].name
  storage_account_id = azurerm_storage_account.this.id
  resource           = "directory"
}

# Private Endpoint
resource "azurerm_private_endpoint" "this" {
  count               = var.sa_info.private_endpoint ? 1 : 0
  name                = "${azurerm_storage_account.this.name}-pep"
  resource_group_name = var.sa_info.resource_group_name
  location            = var.sa_info.resource_group_location
  subnet_id           = var.snet_pep_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  private_service_connection {
    name                           = "${azurerm_storage_account.this.name}-privatelink"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
  }
}
