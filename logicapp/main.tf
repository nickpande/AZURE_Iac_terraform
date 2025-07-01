provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "logicapp-rg"
  location = "East US"
}

resource "azurerm_storage_account" "storage" {
  name                     = "logicappstorage${random_id.storage_suffix.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_id" "storage_suffix" {
  byte_length = 4
}

resource "azurerm_app_service_plan" "logicapp_plan" {
  name                = "logicapp-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "WorkflowStandard"
    size = "WS1"
  }
}

resource "azurerm_logic_app_standard" "logicapp" {
  name                       = "logicapp-sample"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.logicapp_plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true
  }

  workflow {
    name = "myworkflow"
    definition = jsonencode({
      "$schema" = "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
      "contentVersion" = "1.0.0.0",
      "actions" = {
        "Response" = {
          "type" = "Response",
          "inputs" = {
            "statusCode" = 200,
            "body" = {
              "message" = "Hello from Logic App!"
            }
          }
        }
      },
      "triggers" = {
        "manual" = {
          "type" = "Request",
          "kind" = "Http",
          "inputs" = {
            "schema" = {}
          }
        }
      }
    })
  }
}
