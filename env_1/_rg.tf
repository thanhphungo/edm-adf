resource "azurerm_resource_group" "this" {
  name     = "Rg-Edm-Adf-Env1"
  location = "USGov Virginia"
  tags     = local.tags
}
