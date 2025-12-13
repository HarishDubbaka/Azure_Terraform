resource "azurerm_resource_group" "example" {
  name     = var.project_name
  location = var.allowed_locations[2]

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_network" "example" {
  name                = "harish-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }
}

output "resource_group_name" {
    value = azurerm_resource_group.example.name
  
}
output "virtual_network_name" {
    value = azurerm_virtual_network.example.name
}   

