using './main.bicep'

// General Parameters
param parLocations = [
  'northeurope'
  'westeurope'
]
param parEnableTelemetry = true

// Subscription IDs
var loggingSubscriptionId = '82bb18d3-35c3-43a3-afc4-3159d9a1b2a9'
var securitySubscriptionId = '0b4a033d-028f-4f5c-8a9a-eed7254d75ed'

// Log Analytics workspace resource IDs
var loggingWorkspaceResourceId = '/subscriptions/${loggingSubscriptionId}/resourcegroups/rg-alz-logging-${parLocations[0]}/providers/Microsoft.OperationalInsights/workspaces/law-alz-${parLocations[0]}'
var securityWorkspaceResourceId = '/subscriptions/${securitySubscriptionId}/resourcegroups/rg-alz-security-logging-001/providers/Microsoft.OperationalInsights/workspaces/alz-security-log-analytics'

param intRootConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: 'alz'
  managementGroupParentId: 'b49d832f-afca-4666-aa71-5b7c35ac56b3'
  managementGroupDisplayName: 'Azure Landing Zones'
  managementGroupDoNotEnforcePolicyAssignments: []
  managementGroupExcludedPolicyAssignments: []
  customerRbacRoleDefs: []
  customerRbacRoleAssignments: []
  customerPolicyDefs: []
  customerPolicySetDefs: []
  customerPolicyAssignments: [
    {
      id: '/providers/Microsoft.Management/managementGroups/alz/providers/Microsoft.Authorization/policyAssignments/Deploy-Diag-Firewall'
      identity: {
        type: 'SystemAssigned'
      }
      location: 'northeurope'
      name: 'Deploy-Diag-Firewall'
      properties: {
        displayName: 'Deploy Diagnostic Settings for Firewall to Log Analytics workspace'
        description: 'Deploys the diagnostic settings for Firewall to stream to a Log Analytics workspace when any Firewall which is missing this diagnostic settings is created or updated.'
        enforcementMode: 'Default'
        metadata: {}
        nonComplianceMessages: [
          {
            message: 'Diagnostic settings for Azure Firewall must be deployed to send logs to Log Analytics.'
          }
        ]
        notScopes: []
        overrides: []
        parameters: {
          logAnalytics: {
            value: securityWorkspaceResourceId
          }
          effect: {
            value: 'DeployIfNotExists'
          }
        }
        policyDefinitionId: '/providers/Microsoft.Management/managementGroups/alz/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-Firewall'
        resourceSelectors: []
        scope: '/providers/Microsoft.Management/managementGroups/alz'
        roleDefinitionIds: [
          '/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa'
          '/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293'
        ]
      }
      type: 'Microsoft.Authorization/policyAssignments'
    }
  ]
  subscriptionsToPlaceInManagementGroup: []
  waitForConsistencyCounterBeforeCustomPolicyDefinitions: 10
  waitForConsistencyCounterBeforeCustomPolicySetDefinitions: 10
  waitForConsistencyCounterBeforeCustomRoleDefinitions: 10
  waitForConsistencyCounterBeforePolicyAssignments: 40
  waitForConsistencyCounterBeforeRoleAssignments: 40
  waitForConsistencyCounterBeforeSubPlacement: 10
}

// Only specify the parameters you want to override - others will use defaults from JSON files
param parPolicyAssignmentParameterOverrides = {
  'Deploy-MDFC-Config-H224': {
    parameters: {
      logAnalytics: {
        value: loggingWorkspaceResourceId
      }
      emailSecurityContact: {
        value: 'security@yourcompany.com'
      }
      ascExportResourceGroupName: {
        value: 'rg-alz-asc-${parLocations[0]}'
      }
      ascExportResourceGroupLocation: {
        value: parLocations[0]
      }
    }
  }
  'Deploy-AzActivity-Log': {
    parameters: {
      logAnalytics: {
        value: loggingWorkspaceResourceId
      }
      logsEnabled: {
        value: 'True'
      }
    }
  }
  'Deploy-Diag-LogsCat': {
    parameters: {
      logAnalytics: {
        value: loggingWorkspaceResourceId
      }
    }
  }
  'Deploy-SvcHealth-BuiltIn': {
    parameters: {
      resourceGroupLocation: {
        value: parLocations[0]
      }
      actionGroupResources: {
        value: {
          actionGroupEmail: ['triage@yourcompany.com']
          eventHubResourceId: []
          functionResourceId: ''
          functionTriggerUrl: ''
          logicappCallbackUrl: ''
          logicappResourceId: ''
          webhookServiceUri: []
        }
      }
    }
  }
  'Deploy-AzSqlDb-Auditing': {
    parameters: {
      logAnalyticsWorkspaceResourceId: {
        value: loggingWorkspaceResourceId
      }
    }
  }
}
