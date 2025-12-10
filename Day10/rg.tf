resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.allowed_locations[1]
}
