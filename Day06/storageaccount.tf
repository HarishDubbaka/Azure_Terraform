# Create a Storage Account inside the Resource Group
resource "azurerm_storage_account" "example" {
  name                     = "dubbakas1"  # Must be globally unique and lowercase
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location  # Implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}
