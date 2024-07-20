param location string = resourceGroup().location

param storageNamePrefix string
param acr_name string = 'manuacr'
param asb_name string = 'manuasb'
param app_name string = 'manuapp'

var asp_name = 'ASP-${app_name}'

var stgacc_name = '${storageNamePrefix}${uniqueString(resourceGroup().id)}'

resource storage_account 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: stgacc_name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}


resource container_registry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: acr_name
  location: location
  sku: {
    name: 'Basic'
  }
  properties:{
    adminUserEnabled:true
  }
}

resource asb 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: asb_name
  location: location
}

resource hostingPlanName_resource 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: asp_name
  location: location
  kind:'linux'
  sku:{
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  dependsOn:[]
}

resource name_resource 'Microsoft.Web/sites@2023-12-01' = {
  name: app_name
  location: location
  tags:null
  properties:{
    serverFarmId: asp.id
    clientAffinityEnabled:false
    httpsOnly:true
  }
  dependsOn:[]
}
