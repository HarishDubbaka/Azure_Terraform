resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.allowed_locations[0]
}

resource "azurerm_storage_account" "example" {
  #count  = var.storage_account_count
  #name  = var.storage_account_names(count.index)
  for_each = var.storage_account_names
  name                     = each.value
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  

  tags = {
    environment = "staging"
  }
}
