locals {
  prefix  = "EDM-DEMO-ENV1"
  prefix2 = "edmdemoenv1"

  rg  = azurerm_resource_group.this.name
  loc = azurerm_resource_group.this.location

  tags = {
    Project    = "ADF CI/CD"
    CostCenter = "Security"
  }
}
