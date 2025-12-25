output "config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

