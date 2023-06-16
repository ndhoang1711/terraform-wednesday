resource "azurerm_virtual_network_peering" "peering-hn-hq" {
  name = "HN2HQ"
  resource_group_name = azurerm_resource_group.RG-HN.name
  virtual_network_name = azurerm_virtual_network.VNet-web-HN.name
  remote_virtual_network_id = azurerm_virtual_network.VNet-web.id

}

resource "azurerm_virtual_network_peering" "peering-hq-hn" {
  name = "HQ2HN"
  resource_group_name = azurerm_resource_group.rg_vpn.name
  virtual_network_name = azurerm_virtual_network.VNet-web.name
  remote_virtual_network_id = azurerm_virtual_network.VNet-web-HN.id
}



