variable "rgname" {
  description = "Resource group name"
}

variable "location" {
  description = "Azure region"
  default     = "East US"
}

variable "keyvault_name" {
  description = "Key Vault name"
}

variable "aks_name" {
  description = "AKS cluster name"
}

variable "aks_dns_prefix" {
  description = "AKS DNS prefix"
}

variable "node_count" {
  description = "AKS node count"
  default     = 1
}

variable "vm_size" {
  description = "AKS node VM size"
  default     = "Standard_DS2_v2"
}
