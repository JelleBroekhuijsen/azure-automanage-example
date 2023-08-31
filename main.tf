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

