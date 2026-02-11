param name string
param location string = resourceGroup().location
param tags object = {}
param logAnalyticsName string = ''

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: !empty(logAnalyticsName) ? logAnalyticsName : name
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output logAnalyticsWorkspaceId string = logAnalytics.id
output logAnalyticsWorkspaceName string = logAnalytics.name
