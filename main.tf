resource "random_string" "seed" { // This is a random string used to generate a unique name for the storage account
  length  = 4
  special = false
  upper   = false
  number  = false
}

resource "random_uuid" "policy-template-guid" {} // This is a random GUID used to generate a unique name for the policy template

resource "azurerm_resource_group" "rg" { // This is the resource group that will contain all the resources
  name     = "azure-automanage-example-rg"
  location = "westeurope"
}

# resource "azurerm_log_analytics_workspace" "logs" {
#   name                = "azure-automanage-example-log"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }

# resource "azurerm_automation_account" "automation" {
#   name                = "azure-automanage-example-aa"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku_name            = "Basic"
# }