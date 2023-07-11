locals {
  sa_info = {
    name                     = "${local.prefix2}sa"
    resource_group_name      = local.rg
    resource_group_location  = local.loc
    account_tier             = "Standard"
    account_kind             = "StorageV2"
    account_replication_type = "LRS"
    access_tier              = "Hot"
    is_hns_enabled           = false
    encrypt_with_cmk         = false
    private_endpoint         = false
    diagnostics_enabled      = false

    containers = {
      c1 = {
        name        = "test"
        access_type = "private"
      }
    }

    filesystems = {}

    paths = {}
  }
}

module "sa" {
  count = var.deployment_conditions.sa == "yes" ? 1 : 0

  source = "../modules/sa"

  sa_info                    = local.sa_info
  tags                       = local.tags
  allowed_ips                = var.allowed_ips
  allowed_subnet_ids         = []
  snet_pep_id                = "TBD"
  private_dns_zone_ids       = ["TBD"]
  log_analytics_workspace_id = "TBD"
  firewall_defautl_action    = "Allow" # "Deny"
}

# Encryption with CMK
resource "azurerm_key_vault_key" "sa" {
  count        = var.deployment_conditions.sa == "yes" && local.sa_info.encrypt_with_cmk ? 1 : 0
  name         = "key-${module.sa[0].sa_name}"
  key_vault_id = module.kvt[0].kvt_id
  key_type     = "RSA-HSM"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

  depends_on = [
    azurerm_role_assignment.sa_kvt
  ]
}

resource "azurerm_storage_account_customer_managed_key" "sa" {
  count              = var.deployment_conditions.sa == "yes" && local.sa_info.encrypt_with_cmk ? 1 : 0
  storage_account_id = module.sa[0].sa_id
  key_vault_id       = module.kvt[0].kvt_id
  key_name           = azurerm_key_vault_key.sa[0].name
}

output "sa_id" {
  value = var.deployment_conditions.sa == "yes" ? module.sa[0].sa_id : null
}

# Create secret in Key Vault
resource "azurerm_key_vault_secret" "sa_access_key" {
  count        = var.deployment_conditions.sa == "yes" ? 1 : 0
  name         = "sa-access-key"
  value        = module.sa[0].sa_secondary_access_key
  key_vault_id = module.kvt[0].kvt_id
  depends_on = [
    azurerm_role_assignment.tf_kvt
  ]
}
