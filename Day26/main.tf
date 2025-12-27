resource "azurerm_resource_group" "example" {
  name     = var.project_name
  location = var.allowed_locations[2]
}

resource "azurerm_sql_server" "example" {
  name                         = "mysqlserver"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "mradministrator"
  administrator_login_password = "thisIsDog11"

  tags = {
    environment = "production"
  }
}

# Create a sample SQL Database
resource "azurerm_mssql_database" "sampledb" {
  name = "sampledb"
  server_id = azurerm_mssql_server.sql_server.id
}

# Create a Firewall rule
resource "azurerm_mssql_firewall_rule" "firewall_rule" {
  name = "my-sql-sever-firewall"
  server_id = azurerm_mssql_server.sql_server.id
  start_ip_address = "YOUR_PUBLIC_IP"  # Replace with your public IP
  end_ip_address   = "YOUR_PUBLIC_IP"  # Replace with your public IP"
}
