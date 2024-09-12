targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param demoBeerVotingBackendExists bool
@secure()
param demoBeerVotingBackendDefinition object
param demoBeerVotingFrontendExists bool
@secure()
param demoBeerVotingFrontendDefinition object

@description('Id of the user or app to assign application roles')
param principalId string

@description('Login name for the SQL Server admin')
param sqlServerAdminLogin string

@description('Password for the SQL Server admin')
@secure()
param sqlServerAdminPassword string

// Tags that should be applied to all resources.
// 
// Note that 'azd-service-name' tags should be applied separately to service host resources.
// Example usage:
//   tags: union(tags, { 'azd-service-name': <service name in azure.yaml> })
var tags = {
  'azd-env-name': environmentName
}

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = substring(toLower(uniqueString(subscription().id, environmentName, location)), 0, 6)  // adding subtring to limit the length of the resource token

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module monitoring './shared/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
    tags: tags
    logAnalyticsName: '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
    applicationInsightsName: '${abbrs.insightsComponents}${resourceToken}'
  }
  scope: rg
}

module dashboard './shared/dashboard-web.bicep' = {
  name: 'dashboard'
  params: {
    name: '${abbrs.portalDashboards}${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    location: location
    tags: tags
  }
  scope: rg
}

module registry './shared/registry.bicep' = {
  name: 'registry'
  params: {
    location: location
    tags: tags
    name: '${abbrs.containerRegistryRegistries}${resourceToken}'
  }
  scope: rg
}

module keyVault './shared/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    tags: tags
    name: '${abbrs.keyVaultVaults}${resourceToken}'
    principalId: principalId
  }
  scope: rg
}

module sql './shared/sql.bicep' = {
  name: 'sql'
  params: {
    location: location
    tags: tags
    sqlServerName: '${abbrs.sqlServers}${resourceToken}'
    sqlServerAdminLogin: sqlServerAdminLogin
    sqlServerAdminPassword: sqlServerAdminPassword
    sqlDatabaseName: '${abbrs.sqlServersDatabases}${resourceToken}'
  }
  scope: rg
}

module appsEnv './shared/apps-env.bicep' = {
  name: 'apps-env'
  params: {
    name: '${abbrs.appManagedEnvironments}${resourceToken}'
    location: location
    tags: tags
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    logAnalyticsWorkspaceName: monitoring.outputs.logAnalyticsWorkspaceName
  }
  scope: rg
}

module demoBeerVotingBackend './app/Demo.BeerVoting.Backend.bicep' = {
  name: 'Demo.BeerVoting.Backend'
  params: {
    name: '${abbrs.appContainerApps}beervote-backend-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}beervote-backend-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: demoBeerVotingBackendExists
    appDefinition: demoBeerVotingBackendDefinition
    // customization
    sqlConnectionString: 'Server=tcp:${sql.outputs.sqlServerFqdn},1433;Initial Catalog=${sql.outputs.sqlDatabaseName};Persist Security Info=False;User ID=${sqlServerAdminLogin};Password=${sqlServerAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
  }
  scope: rg
}

module demoBeerVotingFrontend './app/Demo.BeerVoting.Frontend.bicep' = {
  name: 'Demo.BeerVoting.Frontend'
  params: {
    name: '${abbrs.appContainerApps}beervote-frontend-${resourceToken}'
    location: location
    tags: tags
    identityName: '${abbrs.managedIdentityUserAssignedIdentities}beervote-frontend-${resourceToken}'
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: appsEnv.outputs.name
    containerRegistryName: registry.outputs.name
    exists: demoBeerVotingFrontendExists
    appDefinition: demoBeerVotingFrontendDefinition
    // customization
    backendHostUri: demoBeerVotingBackend.outputs.uri
  }
  scope: rg
}

output AZURE_CONTAINER_REGISTRY_ENDPOINT string = registry.outputs.loginServer
output AZURE_KEY_VAULT_NAME string = keyVault.outputs.name
output AZURE_KEY_VAULT_ENDPOINT string = keyVault.outputs.endpoint
