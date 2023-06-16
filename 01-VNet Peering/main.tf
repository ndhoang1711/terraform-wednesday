
variable "prefix" {
  default = "HQ"
}

resource "azurerm_resource_group" "RG-HQ" {
  name     = "${var.prefix}-RG_HeadQuarter"
  location = "southeastasia"
}
resource "azurerm_virtual_network" "VNet-HQ" {
  name                = "${var.prefix}-VNet-main"
  location            = azurerm_resource_group.RG-HQ.location
  resource_group_name = azurerm_resource_group.RG-HQ.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "Subnet-HQ" {
  name                 = "${var.prefix}-Subnet-HQ"
  virtual_network_name = azurerm_virtual_network.VNet-HQ.name
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.RG-HQ.name

}

resource "azurerm_public_ip" "pip-db1" {
  name = "${var.prefix}-pip-db1"
  location = azurerm_resource_group.RG-HN.location
  resource_group_name = azurerm_resource_group.RG-HQ.name
  allocation_method = "Dynamic"

}

resource "azurerm_network_interface" "nic-db1" {
  name                = "${var.prefix}-nic-db1"
  location            = azurerm_resource_group.RG-HQ.location
  resource_group_name = azurerm_resource_group.RG-HQ.name
  ip_configuration {
    name                          = "nic-DB1"
    subnet_id                     = azurerm_subnet.Subnet-HQ.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip-db1.id
  }
}

resource "azurerm_linux_virtual_machine" "DB2" {
  name                  = "${var.prefix}-VMDB1"
  resource_group_name   = azurerm_resource_group.rg_vpn.name
  location              = azurerm_resource_group.rg_vpn.location
  size                  = "Standard_B1ls"
  admin_username        = "ndhoang1711"
  admin_password        = "SimpleP@ssw0rd"
  disable_password_authentication = "false"
  network_interface_ids = [azurerm_network_interface.nic-db1.id, ]
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
