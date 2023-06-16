resource "azurerm_resource_group" "rg1" {
  name     = var.azure-rg-1
  location = var.loc1
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_resource_group" "rg2" {
  name     = var.azure-rg-2
  location = var.loc1
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_virtual_network" "vnet-hub" {
  name                = var.region1-vnet1-name
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.loc1
  address_space       = [var.region1-vnet1-address-space]
  dns_servers         = ["10.10.1.4", "8.8.8.8"]
}

resource "azurerm_subnet" "snet-infra1" {
  name                 = var.region1-vnet1-snet1-name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = [var.region1-vnet1-snet1-range]
}
resource "azurerm_subnet" "snet-infra2" {
  name                 = var.region1-vnet1-snet2-name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = [var.region1-vnet1-snet2-range]
}
resource "azurerm_subnet" "snet-infra3" {
  name                 = var.region1-vnet1-snet3-name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = [var.region1-vnet1-snet3-range]
}

resource "azurerm_subnet" "snet-fw" {
  name                 = var.region1-vnet1-snetfw-name
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = [var.region1-vnet1-snetfw-range]
}
resource "azurerm_virtual_network" "vnet-spoke" {
  name                = var.region1-vnet2-name
  resource_group_name = azurerm_resource_group.rg2.name
  location            = var.loc1
  address_space       = [var.region1-vnet2-address-space]
  dns_servers         = ["10.10.1.4", "8.8.8.8"]
}

resource "azurerm_subnet" "snet-spoke1" {
  name                 = var.region1-vnet2-snet1-name
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [var.region1-vnet2-snet1-range]
}

resource "azurerm_subnet" "snet-spoke2" {
  name                 = var.region1-vnet2-snet2-name
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [var.region1-vnet2-snet2-range]
}

resource "azurerm_subnet" "snet-spoke3" {
  name                 = var.region1-vnet2-snet3-name
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [var.region1-vnet2-snet3-range]
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Netapp/volumes"
      actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

#vnet peering
resource "azurerm_virtual_network_peering" "peer-hub2spoke" {
  name                         = "hub2spoke-peering"
  resource_group_name          = azurerm_resource_group.rg1.name
  virtual_network_name         = azurerm_virtual_network.vnet-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "peer-spoke2hub" {
  name                         = "spoke2hub-peering"
  resource_group_name          = azurerm_resource_group.rg2.name
  virtual_network_name         = azurerm_virtual_network.vnet-spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
#RDP Access Rules for Lab
#Get Client IP Address for NSG
data "http" "clientip" {
  url = "https://ipv4.icanhazip.com/"
}

#NSG
resource "azurerm_network_security_group" "NSG-region1" {
  name                = "region1-nsg"
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg2.name
  security_rule {
    name                       = "RDP-In"
    priority                   = "100"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${chomp(data.http.clientip.response_body)}/32"
    destination_address_prefix = "*"
  }
}

#NSG Association to all Lab Subnets

resource "azurerm_subnet_network_security_group_association" "vnet1-infra1" {
  subnet_id                 = azurerm_subnet.snet-infra1.id
  network_security_group_id = azurerm_network_security_group.NSG-region1.id
}

resource "azurerm_subnet_network_security_group_association" "vnet1-infra2" {
  subnet_id                 = azurerm_subnet.snet-infra2.id
  network_security_group_id = azurerm_network_security_group.NSG-region1.id
}
resource "azurerm_subnet_network_security_group_association" "vnet1-infra3" {
  subnet_id                 = azurerm_subnet.snet-infra3.id
  network_security_group_id = azurerm_network_security_group.NSG-region1.id
}
resource "azurerm_subnet_network_security_group_association" "vnet2-spoke1" {
  subnet_id                 = azurerm_subnet.snet-spoke1.id
  network_security_group_id = azurerm_network_security_group.NSG-region1.id
}
resource "azurerm_subnet_network_security_group_association" "vnet2-spoke2" {
  subnet_id                 = azurerm_subnet.snet-spoke2.id
  network_security_group_id = azurerm_network_security_group.NSG-region1.id
}
#Create KeyVault ID
resource "random_id" "kvname" {
  byte_length = 5
  prefix      = "keyvault"
}
data "azurerm_client_config" "current" {

}
resource "azurerm_key_vault" "kv1" {
  depends_on                  = [azurerm_resource_group.rg2]
  name                        = random_id.kvname.hex
  location                    = var.loc1
  resource_group_name         = azurerm_resource_group.rg2.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions     = ["Get", ]
    secret_permissions  = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set", ]
    storage_permissions = ["Get", ]

  }
}
resource "random_password" "vmpassword" {
  length  = 20
  special = true
}

#create key vault secret
resource "azurerm_key_vault_secret" "kv-vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.result
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on   = [azurerm_key_vault.kv1]
}

#create public IP
resource "azurerm_public_ip" "region1-dc01-pip" {
  name                = "region1-dc01-pip"
  resource_group_name = var.azure-rg-1
  location            = var.loc1
  allocation_method   = "Static"
  sku                 = "Standard"
}

#create Nic and associate PIP
resource "azurerm_network_interface" "region1-dc01-nic" {
  name                = "region1-dc01-nic"
  resource_group_name = var.azure-rg-1
  location            = var.loc1

  ip_configuration {
    name                          = "region1-dc01-ipconfig"
    subnet_id                     = azurerm_subnet.snet-infra1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.region1-dc01-pip.id
  }
}
resource "azurerm_managed_disk" "region1-dc01-data" {
  name                 = "region1-dc01-data"
  location             = var.loc1
  resource_group_name  = var.azure-rg-1
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"
  max_shares           = "2"
}

#create DC VM
resource "azurerm_windows_virtual_machine" "region1-dc01-vm" {
  name                = "region1-dc01-vm"
  location            = var.loc1
  resource_group_name = var.azure-rg-1
  depends_on          = [azurerm_key_vault.kv1]
  size                = var.vmsize-domaincontroller
  admin_username      = var.adminusername
  admin_password      = azurerm_key_vault_secret.kv-vmpassword.value
  network_interface_ids = [
    azurerm_network_interface.region1-dc01-nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

#attach data disk to VM
resource "azurerm_virtual_machine_data_disk_attachment" "region1-dc01-data" {
  managed_disk_id    = azurerm_managed_disk.region1-dc01-data.id
  depends_on         = [azurerm_windows_virtual_machine.region1-dc01-vm]
  virtual_machine_id = azurerm_windows_virtual_machine.region1-dc01-vm.id
  lun                = "10"
  caching            = "None"
}

#Run setup script on dc01-vm
resource "azurerm_virtual_machine_extension" "region1-dc01-basesetup" {
  name                 = "region1-dc01-basesetip"
  virtual_machine_id   = azurerm_windows_virtual_machine.region1-dc01-vm.id
  depends_on           = [azurerm_virtual_machine_data_disk_attachment.region1-dc01-data]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<PROTECTED_SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"./baselab_DCSetup.ps1; exit 0;\""
    }
    PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
            "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/PowerShell/baselab_DCSetup.ps1"
        ]
    }
    SETTINGS
}

#Azure Firewall Setup
#Public IP
resource "azurerm_public_ip" "region1-fw01-pip" {
  name                = "region1-fw01-pip"
  resource_group_name = var.azure-rg-1
  location            = var.loc1
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Firewall Instance
resource "azurerm_firewall" "region1-fw01" {
  name                = "region1-fw01"
  location            = var.loc1
  resource_group_name = var.azure-rg-1
  sku_tier            = "Premium"
  sku_name            = "AZFW_VNet"
  depends_on          = [azurerm_firewall_policy.region1-fw-pol01]
  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.snet-fw.id
    public_ip_address_id = azurerm_public_ip.region1-fw01-pip.id

  }
}

#classic rule
resource "azurerm_firewall_network_rule_collection" "specific-range-rules" {
  name                = "specific-range-firewall-rules"
  azure_firewall_name = azurerm_firewall.region1-fw01.name
  resource_group_name = var.azure-rg-1
  priority            = 100
  action              = "Allow"
  rule {
    name                  = "specific-range-firewall-riles"
    source_addresses      = ["10.0.0.0/16"]
    destination_addresses = [var.region1-gateway-address-space]
    destination_ports     = ["*"]
    protocols             = ["Any"]
  }
}

resource "azurerm_firewall_network_rule_collection" "specific-destination-rules2" {
  name                = "specific-destination-firewall-rules2"
  azure_firewall_name = azurerm_firewall.region1-fw01.name
  resource_group_name = var.azure-rg-1
  priority            = 101
  action              = "Allow"
  rule {
    name                  = "specific-range-firewall-rules"
    source_addresses      = ["10.0.0.0/16"]
    destination_addresses = ["10.10.100.1/32"]
    destination_ports     = ["3389"]
    protocols             = ["TCP"]
  }
}

#Firewall Policy
resource "azurerm_firewall_policy" "region1-fw-pol01" {
  name                = "region1-firewall-policy01"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.loc1
}
# Firewall Policy Rules
resource "azurerm_firewall_policy_rule_collection_group" "region1-policy1" {
  name               = "region1-policy1"
  firewall_policy_id = azurerm_firewall_policy.region1-fw-pol01.id
  priority           = 100

  application_rule_collection {
    name     = "blocked_websites1"
    priority = 500
    action   = "Deny"
    rule {
      name = "dodgy_website"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["*"]
      destination_fqdns = ["jakewalsh.co.uk"]
    }
  }
  network_rule_collection {
    name     = "network_rules1"
    priority = 400
    action   = "Allow"
    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["192.168.1.1", "192.168.1.2"]
      destination_ports     = ["80", "8000-8080"]
    }
  }
}