# -------------------------
# Monitor Action Group
# -------------------------
variable "email" {
  type    = string
  default = "dubbakaharish4@gmail.com"
}

resource "azurerm_monitor_action_group" "main" {
  name                = "example-actiongroup"
  resource_group_name = azurerm_resource_group.app_rg.name
  short_name          = "exampleact"

  email_receiver {
    name          = "sendtoadmin"
    email_address = var.email
  }
}

# -------------------------
# Metric Alerts
# -------------------------
# CPU Alert
resource "azurerm_monitor_metric_alert" "cpu_high" {
  name                = "cpu-high-alert"
  resource_group_name = azurerm_resource_group.app_rg.name
  scopes              = [azurerm_linux_virtual_machine.demo_vm.id]
  description         = "Triggered when CPU > 60% for 5 minutes."

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 60
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

# Memory Alert (threshold ~2GB)
resource "azurerm_monitor_metric_alert" "memory_low" {
  name                = "memory-low-alert"
  resource_group_name = azurerm_resource_group.app_rg.name
  scopes              = [azurerm_linux_virtual_machine.demo_vm.id]
  description         = "Triggered when free memory < 2GB."

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 2147483648   # 2GB in bytes
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}
