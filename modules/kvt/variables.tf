variable "kvt_info" {
  type = object({
    name                            = string
    resource_group_name             = string
    resource_group_location         = string
    tenant_id                       = string
    sku_name                        = string
    enabled_for_deployment          = bool
    enabled_for_disk_encryption     = bool
    enabled_for_template_deployment = bool
    soft_delete_retention_days      = number
    enable_rbac_authorization       = bool
    purge_protection_enabled        = bool
    private_endpoint                = bool
    diagnostics_enabled             = bool
  })
  description = "Information about the Key Vault"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "firewall_defautl_action" {
  type        = string
  description = "values: Allow, Deny"
  default     = "Deny"
}

variable "allowed_ips" {
  type        = list(string)
  description = "List of IP addresses that can access the Key Vault"
  default     = []
}

variable "allowed_subnet_ids" {
  type        = list(string)
  description = "List of IDs of subnets that can access the Key Vault"
  default     = []
}

variable "snet_pep_id" {
  type        = string
  description = "The ID of the subnet for the private endpoint"
}

variable "private_dns_zone_ids" {
  type        = list(string)
  description = "The IDs of the private DNS zones"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of Log Analytics workspace"
  default     = ""
}
