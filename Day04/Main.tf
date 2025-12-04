terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }

  # Remote backend configuration for storing state securely in Azure
  backend "azurerm" {
    resource_group_name  = "TFStateResourceGroup"
    storage_account_name = "day0428303"  # Replace with actual name
    container_name       = "tfstatefile"
    key                  = "terraform.tfstate"
  }

  required_version = ">=1.10.0"
}

# Configure the Azure provider
provider "azurerm" {
  features {}
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
  location                 = azurerm_resource_group.example.location  # Implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}
