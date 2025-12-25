provider "azurerm" {
  features {}
}

# Get current tenant
data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.location
}

# Key Vault
module "keyvault" {
  source              = "./modules/keyvault"
  keyvault_name       = var.keyvault_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name
}

# AKS Cluster
module "aks" {
  source              = "./modules/aks"
  name                = var.aks_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name
  dns_prefix          = var.aks_dns_prefix
  node_count          = var.node_count
  vm_size             = var.vm_size
}

# Grant Key Vault access to AKS Managed Identity
resource "azurerm_key_vault_access_policy" "aks_policy" {
  key_vault_id = module.keyvault.keyvault_id
  tenant_id    = module.aks.managed_identity_tenant_id
  object_id    = module.aks.managed_identity_object_id

  secret_permissions = [
    "Get",
    "List"
  ]
}


# Save kubeconfig locally
resource "local_file" "kubeconfig" {
  depends_on = [module.aks]
  filename   = "./kubeconfig"
  content    = module.aks.kube_config
}
