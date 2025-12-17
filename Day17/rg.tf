resource "azurerm_resource_group" "asp" {
  name     = var.resource_group_name
  location = var.allowed_locations[2]
}
