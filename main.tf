resource "random_string" "seed" {
  length  = 4
  special = false
  upper   = false
  number = false
}
  

resource "azurerm_resource_group" "rg" {
  name     = "azure-automanage-example-rg"
  location = "westeurope"
}

resource "azurerm_storage_account" "st" {
  name                     = "examplest${random_string.seed.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc" {
  name                  = "examplecontainer"
  storage_account_name  = azurerm_storage_account.st.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "blob-cm"{
  name                   = "Config_via_Configuration_Management.zip"
  storage_account_name   = azurerm_storage_account.st.name
  storage_container_name = azurerm_storage_container.sc.name
  type                   = "Block"
  source                 = ".\\Config_via_Configuration_Management.zip"
  depends_on = [ null_resource.package-mof-cm ]
}

resource "azurerm_storage_blob" "blob-policy"{
  name                   = "Config_via_Policy.zip"
  storage_account_name   = azurerm_storage_account.st.name
  storage_container_name = azurerm_storage_container.sc.name
  type                   = "Block"
  source                 = ".\\Config_via_Policy.zip"
  depends_on = [ null_resource.package-mof-policy ]
}
  
# resource "azurerm_virtual_machine_extension" "gc-extension"{
#   name                 = "azure-automanage-example-gc-extension"
#   virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
#   publisher            = "Microsoft.GuestConfiguration"
#   type                 = "GuestConfiguration"
#   type_handler_version = "1.10"
#   settings = <<SETTINGS
# {
#   "configuration": {
#     "settings": {
#       "GuestConfiguration": {
#         "name": "AzureBaseline",
#         "version": "1.*",
#         "configurationParameter": {
#           "Parameter1": {
#             "value": "Value1"
#           },
#           "Parameter2": {
#             "value": "Value2"
#           }
#         }
#       }
#     }
#   }
# }
# SETTINGS
# }