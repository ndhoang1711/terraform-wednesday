vm = {
    "vm-test1" = {
        instance = {
            location = "southeastasia"
            admin_username = "abc123"
            admin_password = "qwertyuiop"
            size = "Standard_B1s"
            
        }
        osDisk = {
            caching = "ReadWrite"
            storageAT = "Standard_LRS"
        }
        sourceImage = {
            publisher = "MicrosoftWindowsServer"
            offer = "WindowsServer"
            sku = "2022-Datacenter"
            version = "latest"
        }
    }
    "vm-test2" = {
        instance = {
            location = "southeastasia"
            admin_username = "abc123"
            admin_password = "qwertyuiop"
            size = "Standard_B1s"
            
        }
        osDisk = {
            caching = "ReadWrite"
            storageAT = "Standard_LRS"
        }
        sourceImage = {
            publisher = "MicrosoftWindowsServer"
            offer = "WindowsServer"
            sku = "2022-Datacenter"
            version = "latest"
        }
    }
}