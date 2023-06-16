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
  subscription_id = "ff064279-f4bc-47a0-a8be-58ce33a49e9f"
}