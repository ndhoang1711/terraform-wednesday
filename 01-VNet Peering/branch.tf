variable "prefix-branch" {
  default = "branch"
}
resource "azurerm_resource_group" "RG-HN" {
  name     = "${var.prefix-branch}-RG_Peering_test"
  location = "southeastasia"
}
resource "azurerm_virtual_network" "VNet-web-HN" {
  name                = "${var.prefix-branch}-VNet_WEB"
  location            = azurerm_resource_group.RG-HN.location
  resource_group_name = azurerm_resource_group.RG-HN.name
  address_space       = ["10.10.0.0/16"]
}
resource "azurerm_subnet" "Subnet_web_db-HN" {
  name                 = "${var.prefix-branch}-SN_DB"
  virtual_network_name = azurerm_virtual_network.VNet-web-HN.name
  address_prefixes =        ["10.10.1.0/24"]
  resource_group_name  = azurerm_resource_group.RG-HN.name

}

resource "azurerm_public_ip" "pip-db1-HN" {
  name = "${var.prefix-branch}-pip-db1"
  location = azurerm_resource_group.RG-HN.location
  resource_group_name = azurerm_resource_group.RG-HN.name
  allocation_method = "Dynamic"

}

resource "azurerm_network_interface" "nic-db1-HN" {
  name                = "${var.prefix-branch}-nic-db1"
  location            = azurerm_resource_group.RG-HN.location
  resource_group_name = azurerm_resource_group.RG-HN.name
  ip_configuration {
    name                          = "${var.prefix-branch}-nic-DB1"
    subnet_id                     = azurerm_subnet.Subnet_web_db-HN.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip-db1-HN.id
  }
}

resource "azurerm_linux_virtual_machine" "DB2-HN" {
  name                  = "${var.prefix-branch}-VMDB1"
  resource_group_name   = azurerm_resource_group.RG-HN.name
  location              = azurerm_resource_group.RG-HN.location
  size                  = "Standard_B1ls"
  admin_username        = "ndhoang1711"
  admin_password        = "SimpleP@ssw0rd"
  disable_password_authentication = "false"
  network_interface_ids = [azurerm_network_interface.nic-db1-HN.id, ]
  
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
