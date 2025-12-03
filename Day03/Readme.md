# 🚀 Azure Resource Provisioning with Terraform

This project demonstrates how to automate the creation of Azure resources (Resource Group & Storage Account) using **Terraform** with the **azurerm provider**.

Manual provisioning in the Azure Portal is fine for small tasks, but when scaling to dozens or hundreds of resources, **Infrastructure as Code (IaC)** is the only way to deliver quickly, consistently, and securely.

---

## 📌 Problem Context
- Team size: 10 members  
- Initial scope: Create Azure resources manually (network, storage, VMs, etc.)  
- Change request: Customer suddenly wants ~100 resources delivered in 2 days  
- Challenge: Manual provisioning is impossible at this scale and timeline  

✅ **Solution**: Use **Terraform + AzureRM provider** to automate deployments.

---

## ⚙️ Prerequisites
- Active **Azure subscription**
- **Terraform CLI** installed → [Install Terraform](https://developer.hashicorp.com/terraform/downloads)
- **Azure CLI** installed → [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Proper Azure permissions (**Contributor** role or higher)

---

## 🔑 Authentication Setup
1. **Login to Azure**
   ```bash
   az login
   ```
   A browser window will open for authentication. After success, your subscription info will be displayed.

2. **Create a Service Principal**
   Replace `<SUBSCRIPTION_ID>` with your actual subscription ID:
   ```bash
   az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
   ```

   This will output values like:
   - `appId`
   - `password`
   - `tenant`

3. **Set Environment Variables**
   ```bash
   export ARM_CLIENT_ID="<APPID_VALUE>"
   export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
   export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
   export ARM_TENANT_ID="<TENANT_VALUE>"
   ```

   > HashiCorp recommends using environment variables instead of hardcoding credentials in Terraform files.

---

## 📄 Terraform Configuration

### Provider Block
```hcl
provider "azurerm" {
  features {}
}
```

### Resource Group
```hcl
resource "azurerm_resource_group" "rg" {
  name     = "example-resources"
  location = "South India"
}
```

### Storage Account
```hcl
resource "azurerm_storage_account" "storage" {
  name                     = "dubbakas"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

---

## ▶️ Deployment Steps
1. **Initialize Terraform**
Initializes Terraform in the working directory and downloads the required providers (like azurerm).
   ```bash
   terraform init
   ```
2. **Validate configuration**
Checks if your Terraform configuration syntax is correct.
   ```bash
   terraform validate
   ```
3. **Preview changes**
previews changes Terraform will make without applying them.
Shows what will be created (+), changed (~), or destroyed (-).
Using grep filters the output to only show resources that will be created.
   ```bash
   terraform plan
   terraform plan | grep "will be created"
   
   ```
4. **Apply configuration**
Applies the configuration and creates the Azure resources without asking for confirmation.
   ```bash
   terraform apply -auto-approve
   ```

---

## ⚠️ Important Note
Changes to a **Storage Account configuration** may cause downtime or additional costs.  
Examples include:
- Changing replication type (e.g., LRS → ZRS / GRS / RA-GRS)  
- Changing the region (e.g., South India → Central India)  
- Changing account kind or performance tier  

Such updates often require **re-creation of the Storage Account**, which can lead to **data loss if not backed up**. Always plan carefully and ensure backups before making configuration changes.

---

## 🎯 Outcome
- A **Resource Group** named `"example-resources` will be created in `South India`.
- A **Storage Account** named `dubbakas` will be provisioned inside that Resource Group.
- This setup can be easily scaled to provision **100+ resources in parallel** by adjusting Terraform modules and variables.

---
🗑️ Safe destroy with backups
Destroying without backups is risky and can permanently delete data. Use this checklist and flow.

##- Preview full destroy: Review carefully.
terraform plan -destroy
- Destroy: Proceed only after backup verification.
 ```bash
   terraform destroy 
   ```
- Post-checks: Confirm no stragglers in the subscription; document artifacts and restore points.

Important:

- Data loss is irreversible after destroy. Verify backups and restore paths.
- Do not destroy production-tagged resources. Use tags and prevent_destroy to guard them.

🎯 Outcome
- A Resource Group and Storage Account are provisioned via Terraform.
- Safe defaults reduce accidental data loss.
- Lifecycle includes a clear, backup-first destroy process.


## 📚 References
- [Terraform AzureRM Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Azure CLI Documentation](https://learn.microsoft.com/en-us/cli/azure/)


