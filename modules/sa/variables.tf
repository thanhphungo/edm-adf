variable "sa_info" {
  type = object({
    name                     = string
    resource_group_name      = string
    resource_group_location  = string
    account_tier             = string
    account_kind             = string
    account_replication_type = string
    is_hns_enabled           = bool
    encrypt_with_cmk         = bool
    private_endpoint         = bool
    diagnostics_enabled      = bool

    containers = map(object({
      name        = string
      access_type = string
    }))

    filesystems = map(object({
      name = string
    }))

    paths = map(object({
      name = string
      fs   = string
    }))
  })
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
  description = "List of IP addresses that can access the Storage Account"
  default     = []
}

variable "allowed_subnet_ids" {
  type        = list(string)
  description = "List of IDs of subnets that can access the Storage Account"
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
