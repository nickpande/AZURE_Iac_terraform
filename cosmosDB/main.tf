provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "cosmosdb-demo-rg"
  location = "East US"
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmos" {
  name                = "cosmosdbdemoacct123"
  location            =
}