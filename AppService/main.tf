provider "azurerm" {
  features {}
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-appservice-demo"
  location = "East US"
}

# 2. App Service Plan
resource "azurerm_app_service_plan" "asp" {
  name                = "appserviceplan-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true  # Required for Linux

  sku {
    tier = "Basic"
    size = "B1"
  }
}

# 3. App Service (Web App)
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-demo-1234"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_app_service_plan.asp.id

  site_config {
    always_on = true
    linux_fx_version = "DOCKER|nginx" # Use custom image or runtime stack
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "APP_ENV" = "production"
  }
}
