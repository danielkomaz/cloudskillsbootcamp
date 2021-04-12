provider "azurerm" {
  features {}
}

module "azure-region" {
  source  = "claranet/regions/azurerm"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "windowsservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = module.rg.resource_group_name
  is_windows_image    = true
  vm_hostname         = var.vm.name
  admin_password      = var.vm.admin_password
  vm_os_simple        = "WindowsServer"
  public_ip_dns       = [var.vm.public_dns_name] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
  identity_type       = "SystemAssigned"

  depends_on = [module.rg]
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = module.rg.resource_group_name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  depends_on = [module.rg]
}

module "key_vault" {
  source  = "claranet/keyvault/azurerm"

  client_name         = var.client_name
  environment         = var.environment
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack
}

output "windows_vm_public_name" {
  value = module.windowsservers.public_ip_dns_name
}