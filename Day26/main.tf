data "azurerm_client_config" "current" {}

################################
# Key Vault
################################
resource "azurerm_key_vault" "kv" {
  name                = "${substr(lower(replace(var.project_name, "_", "-")), 0, 19)}-kv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "Set",
      "List"
    ]
  }
}

################################
# Key Vault Secrets
################################
resource "azurerm_key_vault_secret" "sql_admin_username" {
  name         = "sql-admin-username"
  value        = "mradministrator"
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = "thisIsDog11"
  key_vault_id = azurerm_key_vault.kv.id
}

################################
# Azure SQL Server
################################
resource "azurerm_mssql_server" "sql_server" {
  name                         = "${substr(lower(replace(var.project_name, "_", "-")), 0, 24)}-sql"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"

  administrator_login          = azurerm_key_vault_secret.sql_admin_username.value
  administrator_login_password = azurerm_key_vault_secret.sql_admin_password.value

  public_network_access_enabled = true

  tags = {
    environment = "production"
  }
}

################################
# SQL Database
################################
resource "azurerm_mssql_database" "sampledb" {
  name      = "sampledb"
  server_id = azurerm_mssql_server.sql_server.id
}

################################
# Firewall Rule
################################
resource "azurerm_mssql_firewall_rule" "firewall_rule" {
  name             = "allow-my-ip"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
