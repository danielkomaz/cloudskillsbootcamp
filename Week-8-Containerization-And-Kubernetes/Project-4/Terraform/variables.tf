variable "clusterName" {
  description = "Name of the kubernetes cluster"
  type = string
  default = "cloudskillseks"
}

variable "roleName" {
  description = "Name of the role used for the kubernetes cluster"
  type = string
  default = "cloudskillseks"
}

variable "nodeGroupName" {
  description = "Name of the node group associated to the kubernetes cluster"
  type = string
  default = "cloudskillseksnodes"
}

variable "nodeGroupRoleName" {
  description = "Name of the role used for the kubernetes node group"
  type = string
  default = "cloudskillseksnodes"
}

variable "region" {
  description = "Location for the resource group"
  type = string
  default = "eu-west-2"
}