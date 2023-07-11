# Key Vault
resource "azurerm_key_vault" "this" {
  name                            = var.kvt_info.name
  resource_group_name             = var.kvt_info.resource_group_name
  location                        = var.kvt_info.resource_group_location
  tenant_id                       = var.kvt_info.tenant_id
  sku_name                        = var.kvt_info.sku_name
  enabled_for_deployment          = var.kvt_info.enabled_for_deployment
  enabled_for_disk_encryption     = var.kvt_info.enabled_for_disk_encryption
  enabled_for_template_deployment = var.kvt_info.enabled_for_template_deployment
  soft_delete_retention_days      = var.kvt_info.soft_delete_retention_days
  enable_rbac_authorization       = var.kvt_info.enable_rbac_authorization
  purge_protection_enabled        = var.kvt_info.purge_protection_enabled
  tags                            = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  network_acls {
    default_action             = var.firewall_defautl_action
    bypass                     = "AzureServices"
    ip_rules                   = var.allowed_ips
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }

}

# Private Endpoint
resource "azurerm_private_endpoint" "this" {
  count               = var.kvt_info.private_endpoint ? 1 : 0
  name                = "${azurerm_key_vault.this.name}-pep"
  resource_group_name = var.kvt_info.resource_group_name
  location            = var.kvt_info.resource_group_location
  subnet_id           = var.snet_pep_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  private_service_connection {
    name                           = "${azurerm_key_vault.this.name}-privatelink"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
  }
}
