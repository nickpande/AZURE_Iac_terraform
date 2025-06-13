provider "azurerm" {
  features {}
}

# RESOURCE GROUP
resource "azurerm_resource_group" "rg" {
  name     = "rg-function-container"
  location = "East US"
}

# STORAGE ACCOUNT
resource "azurerm_storage_account" "storage" {
  name                     = "funcblobstorage123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# STORAGE CONTAINER (for blob trigger)
resource "azurerm_storage_container" "blob_container" {
  name                  = "input-container"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# APP SERVICE PLAN
resource "azurerm_app_service_plan" "plan" {
  name                = "function-app-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  reserved            = true # Required for Linux

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

# FUNCTION APP
resource "azurerm_linux_function_app" "function_app" {
  name                = "blobtrigger-function"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_app_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  site_config {
    application_stack {
      docker {
        image_name        = "youracrname.azurecr.io/yourfunctionimage:latest"
        registry_username = azurerm_container_registry.acr.admin_username
        registry_password = azurerm_container_registry.acr.admin_password
      }
    }
  }

  app_settings = {
    "AzureWebJobsStorage" = azurerm_storage_account.storage.primary_connection_string
    "FUNCTIONS_WORKER_RUNTIME" = "python"  # or node, dotnet, etc.
    "BlobStorageConnection" = azurerm_storage_account.storage.primary_connection_string
  }

  identity {
    type = "SystemAssigned"
  }
}

# ACR (Optional, if you don’t have it already)
resource "azurerm_container_registry" "acr" {
  name                = "youracrname"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}
