resource "azurerm_public_ip" "pip" {
  name                = "policy-vm-pip"
  resource_group_name = data.azurerm_resource_group.vm-rg.name
  location            = data.azurerm_resource_group.vm-rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = data.azurerm_resource_group.vm-rg.location
  resource_group_name = data.azurerm_resource_group.vm-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.0.4"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "policy-vm"
  resource_group_name = data.azurerm_resource_group.vm-rg.name
  location            = data.azurerm_resource_group.vm-rg.location
  size                = "Standard_D2ds_v4"
  disable_password_authentication = false
  admin_username      = "azureuser"
  admin_password      = "Kifemachine1234"

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7.7"
    version   = "latest"
  }

}