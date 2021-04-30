variable "clusterName" {
  description = "Name of the kubernetes cluster"
  type = string
  default = "devaks21"
}

variable "location" {
  description = "Location for the resource group"
  type = string
  default = "westeurope"
}

variable "rgName" {
  description = "Name of the resource group"
  type = string
  default = "AKS"
}

variable "nodeCount" {
  description = "Number of nodes deployed within the cluster"
  type = number
  default = 1
}

variable "kubernetesVersion" {
  description = "Kubernetes version used for the cluster"
  type = string
  default = "1.20.5"
}

variable "nodeSize" {
  description = "Size of the deployed nodes"
  type = string
  default = "standard_b2s"
}