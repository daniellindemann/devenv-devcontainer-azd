param location string
param tags object

param sqlServerName string
param sqlServerAdminLogin string
@secure()
param sqlServerAdminPassword string

param sqlDatabaseName string




resource sqlServer 'Microsoft.Sql/servers@2021-11-01' ={
  name: sqlServerName
  location: location
  tags:tags
  properties: {
    version: '12.0'
    administratorLogin: sqlServerAdminLogin
    administratorLoginPassword: sqlServerAdminPassword
    publicNetworkAccess: 'Enabled'
  }
}

resource sqlServerFirewallRuleAzure 'Microsoft.Sql/servers/firewallRules@2021-11-01' = {
  parent: sqlServer
  name: 'AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource sqlServerFirewallRuleEveryone 'Microsoft.Sql/servers/firewallRules@2021-11-01' = {
  parent: sqlServer
  name: 'AllowEveryone'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  tags: tags
  sku: {
    name: 'Basic'
  }
  properties: {
    zoneRedundant: false
    requestedBackupStorageRedundancy: 'Local'
  }
}

output sqlServerName string = sqlServer.name
output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName
output sqlDatabaseName string = sqlDatabase.name
