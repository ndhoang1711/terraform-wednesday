terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.6.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "ff064279-f4bc-47a0-a8be-58ce33a49e9f"
}

resource "azurerm_resource_group" "resoruce_RG" {
  name = "azure-rg-1"
  location = "southeastasia"
}