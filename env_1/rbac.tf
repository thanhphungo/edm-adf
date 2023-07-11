# Grant TF service principal permissions to key vault
resource "azurerm_role_assignment" "tf_kvt" {
  count                = var.deployment_conditions.kvt == "yes" ? 1 : 0
  scope                = module.kvt[0].kvt_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Grant AAD group "EDM Phase 2" permissions to key vault
resource "azurerm_role_assignment" "edm_kvt" {
  count                = var.deployment_conditions.kvt == "yes" ? 1 : 0
  scope                = module.kvt[0].kvt_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.aad_group_object_id
}

# Grant TF service principal permissions to storage account sa
resource "azurerm_role_assignment" "tf_sa" {
  count                = var.deployment_conditions.sa == "yes" ? 1 : 0
  scope                = module.sa[0].sa_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Grant TF service principal permissions to storage account dl
resource "azurerm_role_assignment" "tf_dl" {
  count                = var.deployment_conditions.dl == "yes" ? 1 : 0
  scope                = module.dl[0].sa_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Grant Storage Accounts permissions to Key Vault
resource "azurerm_role_assignment" "sa_kvt" {
  count                = var.deployment_conditions.sa == "yes" && local.sa_info.encrypt_with_cmk ? 1 : 0
  scope                = module.kvt[0].kvt_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = module.sa[0].sa_managed_identity_id
}

resource "azurerm_role_assignment" "dl_kvt" {
  count                = var.deployment_conditions.dl == "yes" && local.dl_info.encrypt_with_cmk ? 1 : 0
  scope                = module.kvt[0].kvt_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = module.dl[0].sa_managed_identity_id
}

# Grant ADF permission to Key Vault
resource "azurerm_role_assignment" "adf_kvt" {
  count                = var.deployment_conditions.adf == "yes" ? 1 : 0
  scope                = module.kvt[0].kvt_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.adf[0].adf_managed_identity_id
}

# Grant ADF permission to Data Lake & Storage Accounts (Layer 1 resources)
resource "azurerm_role_assignment" "adf_dl" {
  count                = var.deployment_conditions.adf == "yes" ? 1 : 0
  scope                = module.dl[0].sa_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.adf[0].adf_managed_identity_id
}

resource "azurerm_role_assignment" "adf_sa" {
  count                = var.deployment_conditions.adf == "yes" ? 1 : 0
  scope                = module.sa[0].sa_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.adf[0].adf_managed_identity_id
}
