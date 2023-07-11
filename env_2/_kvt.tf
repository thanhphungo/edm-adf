locals {
  kvt_info = {
    name                            = "${local.prefix2}kvt"
    resource_group_name             = local.rg
    resource_group_location         = local.loc
    tenant_id                       = var.creds.sub1.tenant_id
    sku_name                        = "standard"
    enabled_for_deployment          = true
    enabled_for_disk_encryption     = true
    enabled_for_template_deployment = true
    soft_delete_retention_days      = 7
    enable_rbac_authorization       = true
    purge_protection_enabled        = true
    private_endpoint                = false
    diagnostics_enabled             = false
  }
}

module "kvt" {
  count = var.deployment_conditions.kvt == "yes" ? 1 : 0

  source = "../modules/kvt"

  kvt_info                   = local.kvt_info
  tags                       = local.tags
  allowed_ips                = var.allowed_ips
  allowed_subnet_ids         = []
  snet_pep_id                = "TBD"
  private_dns_zone_ids       = ["TBD"]
  log_analytics_workspace_id = "TBD"
  firewall_defautl_action    = "Allow" # "Deny"
}

output "kvt_id" {
  value = var.deployment_conditions.kvt == "yes" ? module.kvt[0].kvt_id : null
}
