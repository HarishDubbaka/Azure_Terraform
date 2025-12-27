resource "azurerm_resource_group" "rg" {
  name     = var.project_name
  location = var.allowed_locations[2]
}
