data "azurerm_resource_group" "vm-rg" {
  name = "policy-vm-rg"
}

data "azurerm_subnet" "vm-subnet" {
  name                 = "default"
  virtual_network_name = "policy-vnet"
  resource_group_name  = "policy-vm-rg"
}