provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-postgres-demo"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "postgres-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "postgres-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "postgresqlDelegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "pg-flex-server-demo"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  administrator_login    = "pgadmin"
  administrator_password = "P@ssword12345!" # use Key Vault or secrets manager in production
  version                = "14"
  zone                   = "1"
  storage_mb             = 32768
  sku_name               = "Standard_B1ms"
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.subnet.id
  private_dns_zone_id    = null # for private DNS integration (can be omitted or configured)
  high_availability {
    mode = "Disabled"
  }

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
