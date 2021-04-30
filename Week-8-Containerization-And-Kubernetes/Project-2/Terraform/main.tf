provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rgName
  location = var.location
}

# module "aks" {
#   source              = "Azure/aks/azurerm"
#   resource_group_name = azurerm_resource_group.rg.name
#   kubernetes_version  = var.kubernetesVersion
#   os_disk_size_gb     = 50
#   agents_count        = var.nodeCount
#   prefix              = "test"

#   depends_on = [
#     azurerm_resource_group.rg
#   ]
# }

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.clusterName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks"
  kubernetes_version  = var.kubernetesVersion

  default_node_pool {
    name                 = var.clusterName
    node_count           = var.nodeCount
    vm_size              = var.nodeSize
    orchestrator_version = var.kubernetesVersion
  }

  identity {
    type = "SystemAssigned"
  }
}