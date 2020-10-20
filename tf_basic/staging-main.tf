resource "azurerm_resource_group" "rg_staging" {
  location = "${var.loc}"
  name = "${var.rgname}"
}

resource "azurerm_virtual_network" "stage-vnet" {
  address_space = ["10.10.0.0/16"]
  location = azurerm_resource_group.rg_staging.location
  name = "stage-vnet"
  resource_group_name = azurerm_resource_group.rg_staging.name
}

resource "azurerm_subnet" "stage-subnet" {
  name                  = "stage-subnet"
  resource_group_name   = azurerm_resource_group.rg_staging.name
  virtual_network_name  = azurerm_virtual_network.stage-vnet.name
  address_prefix      = "10.10.10.0/24"
}


resource "azurerm_network_interface" "stage-interface" {
  location            = azurerm_resource_group.rg_staging.location
  name                = "internal"
  resource_group_name = azurerm_resource_group.rg_staging.name
  ip_configuration {
    name                          = "stage-internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.stage-subnet.id
  }
}

resource "azurerm_virtual_machine" "staging-vm" {
  location              = azurerm_resource_group.rg_staging.location
  name                  = "staging-vm"
  network_interface_ids = [azurerm_network_interface.stage-interface.id]
  resource_group_name   = azurerm_resource_group.rg_staging.name
  vm_size               = ""
  storage_os_disk {
    create_option       = ""
    name                = "osdisk"
  }
}