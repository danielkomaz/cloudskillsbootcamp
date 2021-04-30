provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgName
  location = var.location
}

module "aks" {
  source              = "Azure/aks/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  kubernetes_version  = var.kubernetesVersion
  os_disk_size_gb     = 50
  agents_count        = var.nodeCount
  prefix              = "test"

  depends_on = [
    azurerm_resource_group.rg
  ]
}