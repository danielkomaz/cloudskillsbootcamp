provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "cloudskills-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_app_service_plan" "cloudskills-sp" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.cloudskills-rg.location
  resource_group_name = azurerm_resource_group.cloudskills-rg.name
  kind                = "Linux"
  reserved = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "cloudskills-as" {
  name                = var.app_service_name
  location            = azurerm_app_service_plan.cloudskills-sp.location
  resource_group_name = azurerm_app_service_plan.cloudskills-sp.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.cloudskills-sp.id

  site_config {
    linux_fx_version = "NODE|12-lts"
  }
}
