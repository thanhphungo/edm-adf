locals {
  dl_info = {
    name                     = "${local.prefix2}dl"
    resource_group_name      = local.rg
    resource_group_location  = local.loc
    account_tier             = "Standard"
    account_kind             = "StorageV2"
    account_replication_type = "LRS"
    access_tier              = "Hot"
    is_hns_enabled           = true
    encrypt_with_cmk         = false
    private_endpoint         = false
    diagnostics_enabled      = false

    containers = {}

    filesystems = {
      fs1 = {
        name = "test"
      }
    }

    paths = {}
  }
}

module "dl" {
  count = var.deployment_conditions.dl == "yes" ? 1 : 0

  source = "../modules/sa"

  sa_info                    = local.dl_info
  tags                       = local.tags
  allowed_ips                = var.allowed_ips
  allowed_subnet_ids         = []
  snet_pep_id                = "TBD"
  private_dns_zone_ids       = ["TBD"]
  log_analytics_workspace_id = "TBD"
  firewall_defautl_action    = "Allow" # "Deny"
}

# Encryption with CMK
resource "azurerm_key_vault_key" "dl" {
  count        = var.deployment_conditions.dl == "yes" && local.dl_info.encrypt_with_cmk ? 1 : 0
  name         = "key-${module.dl[0].sa_name}"
  key_vault_id = module.kvt[0].kvt_id
  key_type     = "RSA-HSM"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

  depends_on = [
    azurerm_role_assignment.dl_kvt
  ]
}

resource "azurerm_storage_account_customer_managed_key" "dl" {
  count              = var.deployment_conditions.dl == "yes" && local.dl_info.encrypt_with_cmk ? 1 : 0
  storage_account_id = module.dl[0].sa_id
  key_vault_id       = module.kvt[0].kvt_id
  key_name           = azurerm_key_vault_key.dl[0].name
}

output "dl_id" {
  value = var.deployment_conditions.dl == "yes" ? module.dl[0].sa_id : null
}

# Create secret in Key Vault
resource "azurerm_key_vault_secret" "dl_access_key" {
  count        = var.deployment_conditions.dl == "yes" ? 1 : 0
  name         = "dl-access-key"
  value        = module.dl[0].sa_secondary_access_key
  key_vault_id = module.kvt[0].kvt_id
  depends_on = [
    azurerm_role_assignment.tf_kvt
  ]
}
