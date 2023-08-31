// This file is used to deploy a configuration assignment to a VM using the Guest Configuration extension directly, without Azure Policy

resource "azurerm_policy_virtual_machine_configuration_assignment" "configuration-assignment" { // This is the configuration assignment that will apply the configuration to the VM
  name               = "example-configuration-assignment"
  location           = azurerm_resource_group.rg.location
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  configuration {
    assignment_type = "ApplyAndAutoCorrect"
    content_uri     = azurerm_storage_blob.blob-cm.url
    content_hash    = filesha256(".\\Config_via_Configuration_Management.zip")
    version         = "1.0.0"
  }
}