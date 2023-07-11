output "sa_id" {
  value = azurerm_storage_account.this.id
}

output "sa_name" {
  value = azurerm_storage_account.this.name
}

output "sa_managed_identity_id" {
  value = azurerm_storage_account.this.identity[0].principal_id
}

output "sa_primary_blob_endpoint" {
  value = azurerm_storage_account.this.primary_blob_endpoint
}

output "sa_primary_dfs_endpoint" {
  value = azurerm_storage_account.this.primary_dfs_endpoint
}

output "sa_primary_access_key" {
  value = azurerm_storage_account.this.primary_access_key
}

output "sa_secondary_access_key" {
  value = azurerm_storage_account.this.secondary_access_key
}
