provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "example-resource-group"
  location = "East US"
}

resource "azurerm_key_vault" "kv" {
  name                        = "examplekeyvault123" # must be globally unique
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = true
}

data "
