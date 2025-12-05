terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }

  required_version = ">=1.10.0"
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Input variable for environment
variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "development"
}

# Local values for common tags
locals {
  common_tags = {
    environment = var.environment   # dynamic from variable
    owner       = "Harish"
    project     = "TerraformDemo"
  }
}

# Create a Resource Group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "South India"
}

# Create a Storage Account inside the Resource Group
resource "azurerm_storage_account" "example" {
  name                     = "dubbakas"  # Must be globally unique and lowercase
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.common_tags
}

# Output the storage account name
output "storage_account_name" {
  value = azurerm_storage_account.example.name
}
