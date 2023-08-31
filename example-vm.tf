// This file contains the terraform code to deploy a VM with the Guest Configuration extension

resource "azurerm_virtual_network" "vnet" { // This is the virtual network that will contain the VM
  name                = "azure-automanage-example-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "subnet" { // This is the subnet that will contain the VM
  name                 = "azure-automanage-example-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "nsg" { // This is the network security group will allow us to configure RDP access to the VM
  name                = "azure-automanage-example-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  security_rule = [
    {
      name                       = "RDP"
      description = "Allow RDP"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      destination_address_prefixes = []
      destination_application_security_group_ids = []
      destination_port_ranges = []
      source_address_prefixes = []
      source_application_security_group_ids = []
      source_port_ranges = []
    }
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" { // This is the association between the subnet and the network security group
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "pip" { // This is the public IP that will be assigned to the VM
    name                = "azure-automanage-example-pip"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    allocation_method   = "Dynamic"
    sku                 = "Basic"
}

resource "azurerm_network_interface" "nic" { // This is the network interface that will be attached to the VM
  name                = "azure-automanage-example-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_windows_virtual_machine" "vm" { // This is the VM that will be deployed. Note: never hardcode credentials in your code, this is just an example!
  resource_group_name = azurerm_resource_group.rg.name
  name                = "example-vm"
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = "Password1234!"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_virtual_machine_extension" "gc-extension" { // This is the Guest Configuration extension that will be installed on the VM
  name                       = "AzurePolicyforWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.GuestConfiguration"
  type                       = "ConfigurationForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}
