terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "app_rg" {
  name     = "provisioner-dubbaka-rg"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "demo-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
}

# Subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.app_rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# NSG
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "vm-nsg"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Public IP
resource "azurerm_public_ip" "vm_ip" {
  name                = "demo-public-ip"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
  allocation_method   = "Static"
}

# NIC
resource "azurerm_network_interface" "main" {
  name                = "demo-nic"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# Deployment Prep (Start Log)
resource "null_resource" "deployment_prep" {
  triggers = {
    start_time = formatdate("YYYYMMDD-HHmmss", timestamp())
  }

  provisioner "local-exec" {
    command = <<EOT
echo "Deployment started at ${self.triggers.start_time}" > deployment-${self.triggers.start_time}.log
EOT
  }
}

# VM
resource "azurerm_linux_virtual_machine" "harish_vm" {
  name                  = "harish-vm"
  location              = azurerm_resource_group.app_rg.location
  resource_group_name   = azurerm_resource_group.app_rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = "Standard_B1s"

  depends_on = [null_resource.deployment_prep]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "demovm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    # Use absolute path or relative path here
    public_key = file("${path.module}/keys/id_rsa.pub")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "echo '<html><body><h1>#28daysofAZTerraform is Awesome!</h1></body></html>' | sudo tee /var/www/html/index.html",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type        = "ssh"
      user        = "azureuser"
      private_key = file("${path.module}/keys/id_rsa")
      host        = azurerm_public_ip.vm_ip.ip_address
    }
  }

  provisioner "file" {
    source      = "configs/sample.conf"
    destination = "/home/azureuser/sample.conf"

    connection {
      type        = "ssh"
      user        = "azureuser"
      private_key = file("${path.module}/keys/id_rsa")
      host        = azurerm_public_ip.vm_ip.ip_address
    }
  }
}

# Deployment Completion (End Log)
resource "null_resource" "deployment_completion" {
  triggers = {
    end_time = formatdate("YYYYMMDD-HHmmss", timestamp())
  }

  provisioner "local-exec" {
    command = <<EOT
echo "Deployment ended at ${self.triggers.end_time}" >> deployment-${self.triggers.end_time}.log
EOT
  }
}

# Outputs
output "vm_public_ip" {
  value = azurerm_public_ip.vm_ip.ip_address
}
