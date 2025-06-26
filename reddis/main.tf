provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "redis-demo-rg"
  location = "East US"
}

# Redis Cache
resource "azurerm_redis_cache" "redis" {
  name                = "redisdemo1234"  # must be globally unique
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  capacity            = 1                # 1 = 250MB for Basic/Standard
  family              = "C"              # C = Basic/Standard/Premium family
  sku_name            = "Basic"          # options: Basic, Standard, Premium
  enable_non_ssl_port = false            # keep false for production

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }

  tags = {
    environment = "demo"
  }
}
