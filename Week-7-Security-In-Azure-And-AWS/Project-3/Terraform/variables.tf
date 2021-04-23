variable "resource_group_name" {
  description = "Name of the created resource group"
  type = string
}

variable "azure_region" {
  description = "Azure region of all created resources. Defaults to westeurope."
  type = string
  default = "westeurope"
}

variable "vault_name" {
  description = "Name of the Vault. Needs to be globally unique."
  type = string
}

variable "vm" {
  description = "Object with diffent values for the deployed VM. public_dns_name must be globally unique."
  type = object({
    name = string
    size = string
    admin_username = string
    admin_password = string
    public_dns_name = string
  })
}

# variable "vault" {
#   description = "Object with diffent values for the deployed VM. public_dns_name must be globally unique."
#   type = object ({
#     name = string
#     environment = string
#   })
# }