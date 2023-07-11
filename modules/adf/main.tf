# Prep for CMK (User Managed Identity, RBAC, Key Vault Key)
resource "azurerm_user_assigned_identity" "this" {
  count               = var.adf_info.encrypt_with_cmk ? 1 : 0
  resource_group_name = var.adf_info.resource_group_name
  location            = var.adf_info.resource_group_location
  name                = "umi-${var.adf_info.name}"
}

resource "azurerm_role_assignment" "this" {
  count                = var.adf_info.encrypt_with_cmk ? 1 : 0
  scope                = var.kvt_cmk_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.this[0].principal_id
}

resource "azurerm_key_vault_key" "this" {
  count        = var.adf_info.encrypt_with_cmk ? 1 : 0
  name         = "key-${var.adf_info.name}"
  key_vault_id = var.kvt_cmk_id
  key_type     = "RSA-HSM"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

  depends_on = [
    azurerm_role_assignment.this
  ]
}

# Data Factory
resource "azurerm_data_factory" "this" {
  name                             = var.adf_info.name
  resource_group_name              = var.adf_info.resource_group_name
  location                         = var.adf_info.resource_group_location
  managed_virtual_network_enabled  = var.adf_info.managed_virtual_network_enabled
  customer_managed_key_id          = var.adf_info.encrypt_with_cmk ? azurerm_key_vault_key.this[0].id : null
  customer_managed_key_identity_id = var.adf_info.encrypt_with_cmk ? azurerm_user_assigned_identity.this[0].id : null
  public_network_enabled           = var.adf_info.public_network_enabled

  identity {
    type         = var.adf_info.encrypt_with_cmk ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = var.adf_info.encrypt_with_cmk ? [azurerm_user_assigned_identity.this[0].id] : []
  }

  lifecycle {
    ignore_changes = [
      github_configuration
    ]
  }

  tags = var.tags
}

# Private Endpoint
## Portal
resource "azurerm_private_endpoint" "adf-portal" {
  count               = var.adf_info.private_endpoint ? 1 : 0
  name                = "${azurerm_data_factory.this.name}-portal-pep"
  resource_group_name = var.adf_info.resource_group_name
  location            = var.adf_info.resource_group_location
  subnet_id           = var.snet_pep_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_ids_portal
  }

  private_service_connection {
    name                           = "${var.adf_info.name}-portal-privatelink"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_data_factory.this.id
    subresource_names              = ["portal"]
  }
}

## DataFactory
resource "azurerm_private_endpoint" "adf-factory" {
  count               = var.adf_info.private_endpoint ? 1 : 0
  name                = "${azurerm_data_factory.this.name}-factory-pep"
  resource_group_name = var.adf_info.resource_group_name
  location            = var.adf_info.resource_group_location
  subnet_id           = var.snet_pep_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_ids_factory
  }

  private_service_connection {
    name                           = "${var.adf_info.name}-factory-privatelink"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_data_factory.this.id
    subresource_names              = ["dataFactory"]
  }
}
