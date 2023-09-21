// This file is used to deploy a configuration assignment to a VM using the Guest Configuration extension directly, without Azure Policy

resource "azurerm_policy_virtual_machine_configuration_assignment" "configuration-assignment" { // This is the configuration assignment that will apply the configuration to the VM
  name               = "Config_via_Configuration_Management" //This name needs to match the name of the .mof file in the configuration package
  location           = azurerm_resource_group.rg.location
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  configuration {
    assignment_type = "ApplyAndAutoCorrect"
    content_uri     = azurerm_storage_blob.blob-cm.url
    content_hash    = filesha256(".\\Config_via_Configuration_Management.zip")
    version         = "1.0.0"
  }
}

resource "azurerm_policy_virtual_machine_configuration_assignment" "choco-package" { // This is an additional example which applies a configuration to install a Chocolatey package
  name               = "Install_Package_via_Chocolatey" //This name needs to match the name of the .mof file in the configuration package
  location           = azurerm_resource_group.rg.location
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  configuration {
    assignment_type = "ApplyAndAutoCorrect"
    content_uri     = azurerm_storage_blob.blob-choco.url
    content_hash    = filesha256(".\\Install_Package_via_Chocolatey.zip")
    version         = "1.0.0"
  }
}