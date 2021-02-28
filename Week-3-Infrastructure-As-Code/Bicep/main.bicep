param name string = 'dkcloudskillsbootcampteststore'
param location string = 'westeurope'

var storageSku = 'Standard_LRS'

resource storageaccount 'Microsoft.Storage/storageAccounts@2020-08-01-preview' = {
  name: name
  location: location
  kind: 'Storage'
  sku: {
    name: storageSku
  }
  properties: {
    allowBlobPublicAccess: false
  }
}

output id string = storageaccount.id