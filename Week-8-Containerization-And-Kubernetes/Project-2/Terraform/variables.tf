variable "name" {
  description = "Name of the kubernetes cluster"
  type = string
}

variable "location" {
  description = "Location for the resource group"
  type = string
}

variable "rgName" {
  description = "Name of the resource group"
  type = string
}

variable "nodeCount" {
  description = "Number of nodes deployed within the cluster"
  type = number
}

variable "kubernetesVersion" {
  description = "Kubernetes version used for the cluster"
  type = string
}