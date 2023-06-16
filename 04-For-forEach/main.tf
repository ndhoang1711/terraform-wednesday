terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.6.0"
    }
  }
}
provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "rg" {
  name = "rg-test"
  location = "southeastasia"
}

resource "azurerm_windows_virtual_machine" "instance" {
  for_each = var.vm
  name = each.key
  resource_group_name = azurerm_resource_group.rg.name
  location = each.value.instance.location
  admin_password = each.value.instance.admin_password
  admin_username = each.value.instance.admin_username
  size = each.value.instance.size
  os_disk {
    for_each = var.vm
    caching = each.value.osDisk.caching
    storage_account_type = each.value.osDisk.storageAT
  }
  source_image_reference {
    publisher = each.value.sourceImage.publisher
    offer = each.value.sourceImage.offer
    sku = each.value.sourceImage.sku
    version = each.value.sourceImage.version
  }
}
