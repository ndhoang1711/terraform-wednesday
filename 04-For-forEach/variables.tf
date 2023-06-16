variable "vm" {
description = "virtual machine variables"
type = map(object({
  azurerm_windows_virtual_machine = object({
    location = string
    resource_group_name = string
    size = string
    admin_username = string
    admin_password = string

  })
  os_disk = object({
    caching = string
    storage_account_type = string
  }) 
  network_interface_ids = list(string)
  source_image_reference = object({
    publisher = string
    offer = string
    sku = string
    version = string
  })
}))
}