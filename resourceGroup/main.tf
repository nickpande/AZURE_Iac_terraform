provider "azurerm" {
  features {}
}



provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# Resource group creation
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}


