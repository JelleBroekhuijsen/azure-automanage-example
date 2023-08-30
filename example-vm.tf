# resource "azurerm_virtual_network" "vnet" {
#   name                = "azure-automanage-example-vnet"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   address_space       = ["10.0.0.0/24"]
# }

# resource "azurerm_subnet" "subnet" {
#   name                 = "azure-automanage-example-subnet"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.0.0/24"]
# }

# resource "azurerm_network_interface" "nic" {
#   name                = "azure-automanage-example-nic"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_windows_virtual_machine" "vm" {
#   resource_group_name = azurerm_resource_group.rg.name
#   name                = "example-vm"
#   location            = azurerm_resource_group.rg.location
#   size                = "Standard_B2s"
#   admin_username      = "azureuser"
#   admin_password      = "Password1234!"
#   network_interface_ids = [
#     azurerm_network_interface.nic.id,
#   ]
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2019-Datacenter"
#     version   = "latest"
#   }
#   identity {
#     type = "SystemAssigned"
#   }
# }
