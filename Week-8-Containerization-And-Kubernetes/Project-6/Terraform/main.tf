terraform {
 required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = "cloudskillsaci"
  location = "westeurope"
}



resource "azurerm_container_group" "aci_group" {
  name                = "aci-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "public"
  dns_name_label      = "cloudskillsaci"
  os_type             = "Linux"

  container {
    name   = "cloudskills-aci"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

}

output "aci_ip" {
  value = azurerm_container_group.aci_group.ip_address
}