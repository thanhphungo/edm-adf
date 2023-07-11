variable "adf_info" {
  type = object({
    name                            = string
    resource_group_name             = string
    resource_group_location         = string
    managed_virtual_network_enabled = bool
    private_endpoint                = bool
    encrypt_with_cmk                = bool
    diagnostics_enabled             = bool
    public_network_enabled          = bool
  })
  description = "Information about the ADF"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "snet_pep_id" {
  type        = string
  description = "The ID of the subnet for the private endpoint"
}

variable "private_dns_zone_ids_portal" {
  type        = list(string)
  description = "The IDs of the private DNS zones for the portal"
}

variable "private_dns_zone_ids_factory" {
  type        = list(string)
  description = "The IDs of the private DNS zones for the factory"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of Log Analytics workspace"
  default     = ""
}

variable "kvt_cmk_id" {
  type        = string
  description = "The ID of the Key Vault used for CMK"
  default     = ""
}
