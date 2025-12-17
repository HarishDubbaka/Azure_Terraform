resource "azurerm_service_plan" "asp" {
  name                = "appserviceplan"
  resource_group_name = var.resource_group_name
  location            = azurerm_resource_group.asp.location
  os_type             = "Linux"
  sku_name            = "B1"

  # Basic (B1/B2/B3) App Service Plan, and Basic SKUs DO NOT support deployment slots.
  #Standard (S1+)	✅ Supported
 #Premium (P1v2+) ✅ Supported
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "prodwebapp2025"
  resource_group_name = azurerm_resource_group.asp.name
  location            = azurerm_resource_group.asp.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true
  }

  depends_on = [
    azurerm_service_plan.asp
  ]
}

resource "azurerm_linux_web_app_slot" "slot" {
  name           = "prodwebapp2025-slot"
  app_service_id = azurerm_linux_web_app.webapp.id

  site_config {}
}
