output "adf_name" {
  value = azurerm_data_factory.this.name
}
  
output "adf_id" {
  value = azurerm_data_factory.this.id
}

output "adf_managed_identity_id" {
  value = azurerm_data_factory.this.identity[0].principal_id
}
