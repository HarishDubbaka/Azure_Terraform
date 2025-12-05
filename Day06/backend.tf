# Remote backend configuration for storing state securely in Azure
terraform {
      backend "azurerm" {
    resource_group_name  = "TFStateResourceGroup"
    storage_account_name = "day0428303"  # Replace with actual name
    container_name       = "tfstatefile"
    key                  = "terraform.tfstate"
  }
}
