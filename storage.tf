// This file is used to deploy the storage account and container for the configuration files and upload those files to blob storage

resource "azurerm_storage_account" "st" { // This is the storage account that will be used to store the configuration files
  name                     = "examplest${random_string.seed.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc" { // This is the container that will be used to store the configuration files
  name                  = "examplecontainer"
  storage_account_name  = azurerm_storage_account.st.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "blob-cm" { // This is the blob that will contain the configuration file for the configuration assignment
  name                   = "Config_via_Configuration_Management.zip"
  storage_account_name   = azurerm_storage_account.st.name
  storage_container_name = azurerm_storage_container.sc.name
  type                   = "Block"
  source                 = ".\\Config_via_Configuration_Management.zip"
}

resource "azurerm_storage_blob" "blob-policy" { // This is the blob that will contain the configuration file for the policy assignment
  name                   = "Config_via_Policy.zip"
  storage_account_name   = azurerm_storage_account.st.name
  storage_container_name = azurerm_storage_container.sc.name
  type                   = "Block"
  source                 = ".\\Config_via_Policy.zip"
}