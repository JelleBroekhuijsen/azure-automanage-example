// This file is used to deploy the policy definition and assignment for the Automanage Configuration Management Policy

resource "azapi_resource" "automanage-policy" { // This is the policy definition that will be used to deploy the configuration to the VM
  type      = "Microsoft.Authorization/policyDefinitions@2021-06-01"
  name      = "example-policy"
  parent_id = "/providers/Microsoft.Management/managementGroups/${data.azurerm_client_config.current.tenant_id}"
  body      = replace(replace(replace(file(".\\policy-template\\Config_via_Policy_DeployIfNotExists.json"), "###REPLACE_CONTENT_URI###", azurerm_storage_blob.blob-policy.url), "###REPLACE_CONTENT_HASH###", filesha256(".\\Config_via_Policy.zip")),"###REPLACE_GUID###",random_uuid.policy-template-guid.result)
}

resource "azapi_resource" "automanage-policy-assignment" { // This is the policy assignment that will apply the policy definition to the VM
  type      = "Microsoft.Authorization/policyAssignments@2022-06-01"
  name      = "example-policy-assignment"
  parent_id = azurerm_resource_group.rg.id
  location  = "westeurope"
  identity {
    type = "SystemAssigned"
  }
  body = jsonencode({
    properties = {
      displayName        = "Example Automanage Configuration Management Policy Assignment"
      description        = "Example Automanage Configuration Management Policy Assignment"
      enforcementMode    = "Default"
      policyDefinitionId = "${azapi_resource.automanage-policy.id}"
      nonComplianceMessages = [
        {
          message = "This resource is not compliant with the policy."
        }
      ]
    }
  })
}

resource "azurerm_role_assignment" "policy-contributor" { // This is the role assignment that will grant the policy assignment the required permissions to deploy the configuration to the VM
    scope                = azurerm_resource_group.rg.id
    role_definition_name = "Guest Configuration Resource Contributor"
    principal_id         = azapi_resource.automanage-policy-assignment.identity[0].principal_id
}