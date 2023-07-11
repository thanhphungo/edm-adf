# Provider
variable "creds" {
  type = map(object({
    tenant_id       = string
    subscription_id = string
    client_id       = string
    client_secret   = string
  }))
}

# Generic
variable "environment" {
  type        = string
  description = "Cloud environment to deploy resources to (usgovernment, public, etc.)"
  default     = "usgovernment"
}

# Key vault
variable "kvt_secrets" {
  type = map(object({
    name  = string
    value = string
  }))
  description = "Key vault secrets to create"
  default     = {}
}

# Deployment Conditions
variable "deployment_conditions" {
  type        = map(string)
  description = "Deployment conditions: deploy if yes, skip if no"
  default = {
    adf = "no"
    kvt = "no"
    sa  = "no"
    dl  = "no"
  }
}

# Others
variable "allowed_ips" {
  type        = list(string)
  description = "List of IPs used for access control. For example, public IP addresses of developers."
}

variable "aad_group_object_id" {
  type        = string
  description = "Object ID of Azure AD group to grant access to Azure resources"
}
  