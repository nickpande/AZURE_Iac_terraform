provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "appserviceplan-demo-rg"
  location = "East US"
}

# App Service Plan
resource "azurerm_app_service_plan" "asp" {
  name                = "appserviceplan-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"     # Options: Free, Shared, Basic, Standard, PremiumV2, PremiumV3
    size = "S1"           # Size depends on tier (e.g., S1, P1v2, P1v3)
  }

  # Optional: Linux or Windows
  kind = "Linux"

  reserved = true         # true = Linux, false = Windows

  tags = {
    environment = "demo"
  }
}
