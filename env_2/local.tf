locals {
  prefix  = "EDM-DEMO-ENV2"
  prefix2 = "edmdemoenv2"

  rg  = azurerm_resource_group.this.name
  loc = azurerm_resource_group.this.location

  tags = {
    Project    = "ADF CI/CD"
    CostCenter = "Security"
  }
}
