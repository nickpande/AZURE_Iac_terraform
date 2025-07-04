resource "azurerm_virtual_network" "spoke1" {
  name                = "spoke1-vnet"
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_virtual_network_peering" "spoke1-to-hub" {
  name                      = "spoke1-to-hub"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.spoke1.name
  remote_virtual_network_id = var.hub_vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}
