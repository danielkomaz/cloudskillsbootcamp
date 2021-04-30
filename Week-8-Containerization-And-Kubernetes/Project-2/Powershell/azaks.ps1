[CmdletBinding()]
param (

    $name = 'devaks21',
    $location = 'westeurope',
    $rgName = 'AKS',
    $nodeCount = 1,
    $kubernetesVersion = '1.20.5'
)

az group create -l $location -n $rgName
az aks create --generate-ssh-keys `
    --name $name `
    --resource-group $rgName `
    --node-count $nodeCount `
    --kubernetes-version $kubernetesVersion