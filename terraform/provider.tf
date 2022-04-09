## <https://www.terraform.io/docs/providers/azurerm/index.html>
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    version = "2.92.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
    //version = "2.92.0"
  features {}
}


