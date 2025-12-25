resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"  # <-- Managed Identity
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "managed_identity_object_id" {
  value = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "managed_identity_tenant_id" {
  value = azurerm_kubernetes_cluster.aks.identity[0].tenant_id
}
