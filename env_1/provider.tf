terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.62.1"
    }
  }
}

provider "azurerm" {
  tenant_id       = var.creds.sub1.tenant_id
  subscription_id = var.creds.sub1.subscription_id
  client_id       = var.creds.sub1.client_id
  client_secret   = var.creds.sub1.client_secret

  environment = var.environment

  skip_provider_registration = true

  features {}
}
