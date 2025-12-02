Azure + Terraform – Day Task Overview

This document explains how to create Azure resources using the azurerm Terraform provider, along with prerequisites, setup steps, and context on why IaC is essential.

📌 Problem Context

Team size: 10 members

Initial plan: Create Azure resources manually (network, storage, VMs, etc.)

Change request: Customer suddenly needs ~100 resources within 2 days

Challenge: Manual provisioning cannot meet the required speed or accuracy

💡 Solution

Use Infrastructure as Code (IaC) tools such as Terraform to automate resource creation.

Benefits:

⚡ Fast and repeatable deployments

🧩 Consistency (no manual mistakes)

🔄 Version-controlled (Git)

📦 Easily scalable (loops, modules)

📘 Day Task
Your task for today

Get familiar with the Terraform Azure provider documentation:
👉 https://registry.terraform.io/providers/hashicorp/azurerm/latest

Create the following resources using Terraform (azurerm provider):

Resource Group

Storage Account

🔧 Prerequisites

Before using Terraform to deploy Azure resources, ensure the following are ready:

✅ 1. Active Azure subscription
✅ 2. Terraform CLI installed

Verify:

terraform -version

✅ 3. Azure CLI installed

Verify:

az --version

✅ 4. Authenticate using Azure CLI
az login


A browser window will open for authentication.

✅ 5. Create a Service Principal

Terraform uses this identity to authenticate and manage resources.

Replace <SUBSCRIPTION_ID>:

az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"


Output values such as:

appId (Client ID)

password (Client Secret)

tenant (Tenant ID)

✅ 6. Set Terraform environment variables

(Recommended by HashiCorp)

export ARM_CLIENT_ID="<APPID_VALUE>"
export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
export ARM_TENANT_ID="<TENANT_VALUE>"

✅ 7. Add Terraform Azure provider block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}


You're now ready to deploy resources! 🚀

🏗️ Create Azure Resources in Azure Portal (Quick Overview)

Even though creating a storage account in the Azure Portal is simple, different people choose different settings based on:

Performance
Redundancy (LRS, ZRS, GRS, GZRS)
Cost
Security
Compliance requirements

📦 Storage Account – Quick Portal Steps

Go to portal.azure.com
Search Storage Accounts
Click Create
Select Subscription + Resource Group
Enter a unique lowercase storage account name
Choose Region, Performance, Redundancy
Click Review + Create
Click Create

Storage account is ready! 🎉

🧱 Why IaC Matters

When customers request large-scale deployments (e.g., 100 resources in 2 days), manual provisioning becomes impossible.

Using Terraform:

Automates everything
Ensures accuracy
Reduces time drastically
Makes deployments repeatable and predictable

🚀 You're Ready!

You now have everything needed to create:

Resource Group
Storage Account

using Terraform and the AzureRM provider.
