variable "resource_group_name" {
  description = "Name of the created resource group"
  type = string
  default = "westeurope"
}

variable "azure_region" {
  description = "Azure region of all created resources. Defaults to westeurope."
  type = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type = string
}

variable "environment" {
  description = " Project environment"
  type = string
}

variable "stack" {
  description = " Project stack name"
  type = string
}

variable "vm" {
  description = "Object with diffent values for the deployed VM. public_dns_name must be globally unique."
  type = object({
    name = string
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