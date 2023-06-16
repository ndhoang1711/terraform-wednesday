resource "azurerm_resource_group" "region1-rg1" {
  name     = "azure-rg1"
  location = var.loc1
}
resource "azurerm_resource_group" "region2-rg2" {
  name     = "region1-rg2"
  location = var.loc2
}
resource "azurerm_resource_group" "region1-rg3-security" {
  name     = "azure-rg3-security"
  location = var.loc1
}

resource "azurerm_virtual_network" "region1-vnet1-hub" {
  name                = var.region1-vnet1-name
  resource_group_name = azurerm_resource_group.region1-rg1.name
  location            = var.loc1
  address_space       = [var.region1-vnet1-address-space]
  dns_servers         = ["10.10.1.4", "8.8.8.8"]
}

resource "azurerm_virtual_network" "region1-vnet2-spoke" {
  name                = var.region1-vnet2-name
  resource_group_name = azurerm_resource_group.region1-rg1.name
  location            = var.loc1
  address_space       = [var.region1-vnet2-address-space]
  dns_servers         = ["10.10.1.4", "8.8.8.8"]
}

resource "azurerm_virtual_network" "region2-vnet1-hub" {
  name                = var.region2-vnet1-name
  resource_group_name = azurerm_resource_group.region2-rg2.name
  location            = var.loc2
  address_space       = [var.region2-vnet1-address-space]
  dns_servers         = ["10.10.1.4", "8.8.8.8"]
}
resource "azurerm_virtual_network" "region2-vnet2-spoke" {
  name                = var.region2-vnet2-name
  resource_group_name = azurerm_resource_group.region2-rg2.name
  location            = var.loc2
  address_space       = [var.region2-vnet2-address-space]
  dns_servers         = ["10.10.1.4", "8.8.8.8"]
}

resource "azurerm_subnet" "region1-vnet1-snet1" {
  name                 = var.region1-vnet1-snet1-name
  resource_group_name  = azurerm_resource_group.region1-rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet1-hub.name
  address_prefixes     = [var.region1-vnet1-snet1-range]
}

resource "azurerm_subnet" "region1-vnet1-snet2" {
  name                 = var.region1-vnet1-snet2-name
  resource_group_name  = azurerm_resource_group.region1-rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet1-hub.name
  address_prefixes     = [var.region1-vnet1-snet2-range]
}

resource "azurerm_subnet" "region1-vnet1-snet3" {
  name                 = var.region1-vnet1-snet3-name
  resource_group_name  = azurerm_resource_group.region1-rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet1-hub.name
  address_prefixes     = [var.region1-vnet1-snet3-range]
}
resource "azurerm_subnet" "region1-vnet2-snet1" {
  name                 = var.region1-vnet2-snet1-name
  resource_group_name  = azurerm_resource_group.region1-rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet2-spoke.name
  address_prefixes     = [var.region1-vnet2-snet1-range]
}
resource "azurerm_subnet" "region1-vnet2-snet2" {
  name                 = var.region1-vnet2-snet2-name
  resource_group_name  = azurerm_resource_group.region1-rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet2-spoke.name
  address_prefixes     = [var.region1-vnet2-snet2-range]
}
resource "azurerm_subnet" "region1-vnet2-snet3" {
  name                 = var.region1-vnet2-snet3-name
  resource_group_name  = azurerm_resource_group.region1-rg1.name
  virtual_network_name = azurerm_virtual_network.region1-vnet2-spoke.name
  address_prefixes     = [var.region1-vnet2-snet3-range]
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Netapp/volumes"
      actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

#Region2 subnet
resource "azurerm_subnet" "region2-vnet1-snet1" {
  name                 = var.region2-vnet1-snet1-name
  resource_group_name  = azurerm_resource_group.region2-rg2.name
  virtual_network_name = azurerm_virtual_network.region2-vnet1-hub.name
  address_prefixes     = [var.region2-vnet1-snet1-range]
}
resource "azurerm_subnet" "region2-vnet1-snet2" {
  name                 = var.region2-vnet1-snet2-name
  resource_group_name  = azurerm_resource_group.region2-rg2.name
  virtual_network_name = azurerm_virtual_network.region2-vnet1-hub.name
  address_prefixes     = [var.region2-vnet1-snet2-range]
}
resource "azurerm_subnet" "region2-vnet1-snet3" {
  name                 = var.region2-vnet1-snet3-name
  resource_group_name  = azurerm_resource_group.region2-rg2.name
  virtual_network_name = azurerm_virtual_network.region2-vnet1-hub.name
  address_prefixes     = [var.region2-vnet1-snet3-range]
}
resource "azurerm_subnet" "region2-vnet2-snet1" {
  name                 = var.region2-vnet2-snet1-name
  resource_group_name  = azurerm_resource_group.region2-rg2.name
  virtual_network_name = azurerm_virtual_network.region2-vnet2-spoke.name
  address_prefixes     = [var.region2-vnet2-snet1-range]
}
resource "azurerm_subnet" "region2-vnet2-snet2" {
  name                 = var.region2-vnet2-snet2-name
  resource_group_name  = azurerm_resource_group.region2-rg2.name
  virtual_network_name = azurerm_virtual_network.region2-vnet2-spoke.name
  address_prefixes     = [var.region2-vnet2-snet2-range]
}
resource "azurerm_subnet" "region2-vnet2-snet3" {
  name                 = var.region2-vnet2-snet3-name
  resource_group_name  = azurerm_resource_group.region2-rg2.name
  virtual_network_name = azurerm_virtual_network.region2-vnet2-spoke.name
  address_prefixes     = [var.region2-vnet2-snet3-range]
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Netapp/volumes"
      actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

#vnet peering
resource "azurerm_virtual_network_peering" "reg1-vnet1-to-reg1-vnet2" {
  name                         = "reg1-vnet1-to-reg1-vnet2"
  resource_group_name          = azurerm_resource_group.region1-rg1.name
  virtual_network_name         = azurerm_virtual_network.region1-vnet1-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.region1-vnet2-spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "reg1-vnet2-to-reg1-vnet1" {
  name                         = "reg1-vnet2-to-reg1-vnet1"
  resource_group_name          = azurerm_resource_group.region1-rg1.name
  virtual_network_name         = azurerm_virtual_network.region1-vnet2-spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.region1-vnet1-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "reg2-vnet1-to-reg2-vnet2" {
  name                         = "reg2-vnet1-to-reg2-vnet2"
  resource_group_name          = azurerm_resource_group.region2-rg2.name
  virtual_network_name         = azurerm_virtual_network.region2-vnet1-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.region2-vnet2-spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "reg2-vnet2-to-reg2-vnet1" {
  name                         = "reg2-vnet2-to-reg2-vnet1"
  resource_group_name          = azurerm_resource_group.region2-rg2.name
  virtual_network_name         = azurerm_virtual_network.region2-vnet2-spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.region2-vnet1-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "reg1-vnet1-to-reg2-vnet1" {
  name                         = "reg1-vnet1-to-reg2-vnet1"
  resource_group_name          = azurerm_resource_group.region1-rg1.name
  virtual_network_name         = azurerm_virtual_network.region1-vnet1-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.region2-vnet1-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "reg2-vnet1-to-reg1-vnet1" {
  name                         = "reg1-vnet1-to-reg1-vnet1"
  resource_group_name          = azurerm_resource_group.region2-rg2.name
  virtual_network_name         = azurerm_virtual_network.region2-vnet1-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.region1-vnet1-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}


#RDP Access Rules for Lab
#Get Client IP Address for NSG
data "http" "clientip" {
  url = "https://ipv4.icanhazip.com/"
}
#Lab NSGs
#Region 1

resource "azurerm_network_security_group" "nsg-rg1" {
  name = "region1-nsg"
  location = var.loc1
  resource_group_name = azurerm_resource_group.region1-rg1.name
  security_rule {
    name = "RDP In"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    destination_port_range = "3389"
    source_port_range = "*"
    source_address_prefix = "${chomp(data.http.clientip.response_body)}/32"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg-rg2" {
  name = "region2-nsg"
  location = var.loc2
  resource_group_name = azurerm_resource_group.region2-rg2.name
  security_rule {
    name = "RDP In"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    destination_port_range = "3389"
    source_port_range = "*"
    source_address_prefix = "${chomp(data.http.clientip.response_body)}/32"
    destination_address_prefix = "*"
  }
}

# Setup NSG association to all Lab Subnets in each region (excluding ANF subnet)
# Region 1
resource "azurerm_subnet_network_security_group_association" "region1-vnet1-snet1" {
  network_security_group_id = azurerm_network_security_group.nsg-rg1.id
  subnet_id = azurerm_subnet.region1-vnet1-snet1.id
}
resource "azurerm_subnet_network_security_group_association" "region1-vnet1-snet2" {
  network_security_group_id = azurerm_network_security_group.nsg-rg1.id
  subnet_id = azurerm_subnet.region1-vnet1-snet2.id
}
resource "azurerm_subnet_network_security_group_association" "region1-vnet1-snet3" {
  network_security_group_id = azurerm_network_security_group.nsg-rg1.id
  subnet_id = azurerm_subnet.region1-vnet1-snet3.id
}
resource "azurerm_subnet_network_security_group_association" "region1-vnet2-snet1" {
  network_security_group_id = azurerm_network_security_group.nsg-rg1.id
  subnet_id = azurerm_subnet.region1-vnet2-snet1.id
}
resource "azurerm_subnet_network_security_group_association" "region1-vnet2-snet2" {
  network_security_group_id = azurerm_network_security_group.nsg-rg1.id
  subnet_id = azurerm_subnet.region1-vnet2-snet2.id
}

#Region2
resource "azurerm_subnet_network_security_group_association" "region2-vnet1-snet1" {
  network_security_group_id = azurerm_network_security_group.nsg-rg2.id
  subnet_id = azurerm_subnet.region2-vnet1-snet1.id
}
resource "azurerm_subnet_network_security_group_association" "region2-vnet1-snet2" {
  network_security_group_id = azurerm_network_security_group.nsg-rg2.id
  subnet_id = azurerm_subnet.region2-vnet1-snet2.id
}
resource "azurerm_subnet_network_security_group_association" "region2-vnet1-snet3" {
  network_security_group_id = azurerm_network_security_group.nsg-rg2.id
  subnet_id = azurerm_subnet.region2-vnet1-snet3.id
}
resource "azurerm_subnet_network_security_group_association" "region2-vnet2-snet1" {
  network_security_group_id = azurerm_network_security_group.nsg-rg2.id
  subnet_id = azurerm_subnet.region2-vnet2-snet1.id
}
resource "azurerm_subnet_network_security_group_association" "region2-vnet2-snet2" {
  network_security_group_id = azurerm_network_security_group.nsg-rg2.id
  subnet_id = azurerm_subnet.region2-vnet2-snet2.id
}

#create Keyvault ID
resource "random_id" "kvname" {
  byte_length = 5
  prefix = "keyvault"
}

data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv1" {
  depends_on = [ azurerm_resource_group.region1-rg3-security ]
  name = random_id.kvname.hex
  location = var.loc1
  resource_group_name = azurerm_resource_group.region1-rg3-security.name
  enabled_for_disk_encryption = true
  tenant_id = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled = false

    sku_name = "standard"
    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id

        key_permissions = [ "Get", ]
        secret_permissions = [ "Get", "Set", "Delete", "Backup", "List", "Purge", "Recover", "Restore" ]
        storage_permissions = [ "Get", ]
    }
}

#create VM password
resource "random_password" "vmpassword" {
  length = 20
  special = true
}

#create keyvault secret
resource "azurerm_key_vault_secret" "vmpassword" {
  name = "vmpassword"
  value = random_password.vmpassword.result
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on = [ azurerm_key_vault.kv1 ]
}

#create Public IP 
#Region1
resource "azurerm_public_ip" "rg1-dc01-pip" {
  name = "rg1-dc01-pip"
  sku = "Standard"
  allocation_method = "Static"
  location = var.loc1
  resource_group_name = azurerm_resource_group.region1-rg1.name
}

#Region2
resource "azurerm_public_ip" "rg2-dc01-pip" {
  name = "rg2-dc01-pip"
  location = var.loc2
  allocation_method = "Static"
  resource_group_name = azurerm_resource_group.region2-rg2.name
  sku = "Standard"
}

#create NIC and associate PIP
#region1
resource "azurerm_network_interface" "rg1-dc01-nic" {
  name = "rg1-dc01-nic"
  location = azurerm_resource_group.region1-rg1.location
  resource_group_name = azurerm_resource_group.region1-rg1.name
  ip_configuration {
    name = "rg1-dc01-ipconfig"
    subnet_id = azurerm_subnet.region1-vnet1-snet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.rg1-dc01-pip.id

  }

}

#region2
resource "azurerm_network_interface" "rg2-dc01-nic" {
  name = "rg2-dc01-nic"
  location = azurerm_resource_group.region2-rg2.location
  resource_group_name = azurerm_resource_group.region2-rg2.name
  ip_configuration {
    name = "rg2-dc01-ipconfig"
    subnet_id = azurerm_subnet.region2-vnet1-snet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.rg2-dc01-pip.id

  }

}

#Create data disk for NTDS storage
#Region 1
resource "azurerm_managed_disk" "region1-dc01-data" {
    name = "region1-dc01-data"
    location = var.loc1
    resource_group_name = azurerm_resource_group.region1-rg1.name
    disk_size_gb = 10
    max_shares = 2
    storage_account_type = "StandardSSD_LRS"
    create_option = "Empty"
}
#Region 2
resource "azurerm_managed_disk" "region2-dc01-data" {
    name = "region2-dc01-data"
    location = var.loc2
    resource_group_name = azurerm_resource_group.region2-rg2.name
    disk_size_gb = 10
    max_shares = 2
    storage_account_type = "StandardSSD_LRS"
    create_option = "Empty"
}

#create VM Domain controller
#region1

resource "azurerm_windows_virtual_machine" "region1-dc01-vm" {
  name = "region1-dc01-vm"
  location = var.loc1
  depends_on = [ azurerm_key_vault.kv1 ]
  resource_group_name = azurerm_resource_group.region1-rg1.name
  admin_username = var.adminusername
  admin_password = azurerm_key_vault_secret.vmpassword.value
  size = var.vmsize-domaincontroller
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  network_interface_ids = [azurerm_network_interface.rg1-dc01-nic.id,]
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2022-Datacenter"
    version = "latest"
  }
}

#region2
resource "azurerm_windows_virtual_machine" "region2-dc01-vm" {
  name = "region2-dc01-vm"
  location = var.loc1
  depends_on = [ azurerm_key_vault.kv1 ]
  resource_group_name = azurerm_resource_group.region2-rg2.name
  size = var.vmsize-domaincontroller
  admin_username = var.adminusername
  admin_password = azurerm_key_vault_secret.vmpassword.value
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  network_interface_ids = [azurerm_network_interface.rg2-dc01-nic.id,]
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2022-Datacenter"
    version = "latest"
  }
}

#Attach Data Disk to DC Virtual Machines
#Region 1
resource "azurerm_virtual_machine_data_disk_attachment" "region1-dc01-data" {
  managed_disk_id    = azurerm_managed_disk.region1-dc01-data.id
  depends_on         = [azurerm_windows_virtual_machine.region1-dc01-vm]
  virtual_machine_id = azurerm_windows_virtual_machine.region1-dc01-vm.id
  lun                = "10"
  caching            = "None"
}
#Region 2
resource "azurerm_virtual_machine_data_disk_attachment" "region2-dc01-data" {
  managed_disk_id    = azurerm_managed_disk.region2-dc01-data.id
  depends_on         = [azurerm_windows_virtual_machine.region2-dc01-vm]
  virtual_machine_id = azurerm_windows_virtual_machine.region2-dc01-vm.id
  lun                = "10"
  caching            = "None"
}

#Run setup scripts on dc01 virtual machines
#Region1
resource "azurerm_virtual_machine_extension" "region1-dc01-basesetup" {
  name = "region1-dc01-basesetup"
  virtual_machine_id = azurerm_windows_virtual_machine.region1-dc01-vm.id
  depends_on = [ azurerm_virtual_machine_data_disk_attachment.region1-dc01-data ]
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "1.9"
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./baselab_DCSetup1.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/Azure-NetApp-Files-CRR-BaseLab/PowerShell/DC1/baselab_DCSetup1.ps1"
        ]
    }
  SETTINGS
}

#Region2
resource "azurerm_virtual_machine_extension" "region2-dc01-basesetup" {
  name = "region1-dc01-basesetup"
  virtual_machine_id = azurerm_windows_virtual_machine.region2-dc01-vm.id
  depends_on = [ azurerm_virtual_machine_data_disk_attachment.region2-dc01-data ]
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "1.9"
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./baselab_DCSetup1.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/Azure-NetApp-Files-CRR-BaseLab/PowerShell/DC1/baselab_DCSetup1.ps1"
        ]
    }
  SETTINGS
}


#Create Azure NetApp Files Account and Capacity Pool - Region 1
# resource "azurerm_netapp_account" "region1-anf" {
#   name = "region1-anf"
#   location = var.loc1
#   resource_group_name = azurerm_resource_group.region1-rg1.name

# }
# resource "azurerm_netapp_pool" "region1-anf-pool1" {
#   name = "pool1"
#   account_name = azurerm_netapp_account.region1-anf.name
#   location = var.loc1
#   resource_group_name = azurerm_resource_group.region1-rg1.name
#   service_level = "Standard"
#   size_in_tb = 4
# }
# #Create Azure NetApp Files Account and Capacity Pool - Region 2
# resource "azurerm_netapp_account" "region2-anf" {
#   name = "region2-anf"
#   location = var.loc2
#   resource_group_name = azurerm_resource_group.region2-rg2.name

# }
# resource "azurerm_netapp_pool" "region2-anf-pool1" {
#   name = "pool2"
#   account_name = azurerm_netapp_account.region2-anf.name
#   location = var.loc1
#   resource_group_name = azurerm_resource_group.region2-rg2.name
#   service_level = "Standard"
#   size_in_tb = 4
# }