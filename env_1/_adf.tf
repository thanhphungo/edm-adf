locals {
  adf_info = {
    name                            = "${local.prefix2}adf"
    resource_group_name             = local.rg
    resource_group_location         = local.loc
    managed_virtual_network_enabled = false
    private_endpoint                = false
    encrypt_with_cmk                = false
    diagnostics_enabled             = false
    public_network_enabled          = true
  }
}

module "adf" {
  count = var.deployment_conditions.adf == "yes" ? 1 : 0

  source = "../modules/adf"

  adf_info                     = local.adf_info
  tags                         = local.tags
  snet_pep_id                  = "TBD"
  private_dns_zone_ids_portal  = ["TBD"]
  private_dns_zone_ids_factory = ["TBD"]
  log_analytics_workspace_id   = "TBD"
  kvt_cmk_id                   = module.kvt[0].kvt_id
}

output "adf_id" {
  value = var.deployment_conditions.adf == "yes" ? module.adf[0].adf_id : null
}
