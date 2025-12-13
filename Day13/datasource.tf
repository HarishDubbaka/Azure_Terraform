# -----------------------------
# Data sources (existing infra)
# -----------------------------
data "azurerm_resource_group" "shared" {
  name = "Dubbaka_Resourcegroup"
}

data "azurerm_virtual_network" "shared" {
  name                = "harish-network"
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_subnet" "shared" {
  name                 = "subnet1"
  resource_group_name  = data.azurerm_resource_group.shared.name
  virtual_network_name = data.azurerm_virtual_network.shared.name
}

# -----------------------------
# Variables
# -----------------------------
variable "prefix" {
  default = "harish"
}

# -----------------------------
# New Resource Group
# -----------------------------
resource "azurerm_resource_group" "vm_rg" {
  name     = "${var.prefix}-resources"
  location = data.azurerm_resource_group.shared.location
}

# -----------------------------
# NIC
# -----------------------------
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.shared.id
    private_ip_address_allocation = "Dynamic"
  }
}

# -----------------------------
# Virtual Machine
# -----------------------------
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.vm_rg.location
  resource_group_name   = azurerm_resource_group.vm_rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "harishvm"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }
}
