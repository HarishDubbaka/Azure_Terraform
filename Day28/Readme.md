# Terraform Import: Managing Existing Azure Resources as Code

Managing cloud resources efficiently is a key skill for DevOps engineers. Often, Azure resources already exist and were created manually through the Azure Portal. To bring these resources under **Terraform management**, we use **`terraform import`**.

This guide walks through importing an **existing Azure Resource Group** into Terraform and explains **why state files matter**.

---

## 🚀 Scenario

* Resource Group already exists in Azure
* Terraform project is new
* No state file exists
* Terraform plans to **create** resources that already exist

👉 Solution: **Import existing resources into Terraform state**

---

## 🛠️ Step 1: Set Up Terraform Project

### Create Project Structure

```text
Day24/
├── provider.tf
├── main.tf
```

---

## 📄 provider.tf

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

---

## 📄 main.tf

> ⚠️ NOTE: This Resource Group **already exists in Azure**

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "dubbakas"
  location = "South India"
}
```

---

## ▶️ Step 2: Initialize Terraform

```bash
terraform init
```

---

## 🔍 Step 3: Run Terraform Plan (Before Import)

```bash
terraform plan
```

### Output (Expected)

```text
Terraform will perform the following actions:

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + name     = "dubbakas"
      + location = "southindia"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

❌ **Problem:**
Terraform wants to create a Resource Group that already exists.

---

## 🧠 Why Terraform Behaves This Way

Terraform compares:

* **Desired state** → `.tf` files
* **State file** → `terraform.tfstate`
* **Actual state** → Azure

👉 Terraform **does NOT** look directly at Azure unless the resource is in the **state file**.

### Current Situation:

```bash
terraform state list
```

```text
No state file was found!
```

Because the state is empty, Terraform assumes **nothing exists**.

---

## ✅ Solution: Import Existing Resource

### Find Resource ID

In Azure Portal:

```
Resource Group → Settings → Properties → Resource ID
```

Example:

```text
/subscriptions/b504be20-5789-46df-a4bf-25ee1020d7b2/resourceGroups/dubbakas
```

---

## ⚠️ Important: Git Bash Path Conversion Issue

If you are using **Git Bash**, disable path conversion:

```bash
export MSYS_NO_PATHCONV=1
```

---

## ▶️ Step 4: Import Resource Group

```bash
terraform import azurerm_resource_group.rg "/subscriptions/b504be20-5789-46df-a4bf-25ee1020d7b2/resourceGroups/dubbakas"
```

---

## ✅ Step 5: Verify State

```bash
terraform state list
```

Expected output:

```text
azurerm_resource_group.rg
```

---

## 🔄 Step 6: Run Terraform Plan Again

```bash
terraform plan
```

### Output (Expected)

```text
No changes. Your infrastructure matches the configuration.
```

🎉 Terraform now **knows** the resource exists and manages it safely.

---

## 🔑 Key Takeaways

* Terraform relies on the **state file**, not the Azure Portal
* Existing resources must be **imported** before management
* `terraform import` bridges **real infrastructure ↔ Terraform state**
* Never run `terraform apply` before importing existing resources

---

## 📌 Best Practices

✔ Always write `.tf` first
✔ Import existing resources before apply
✔ Verify with `terraform plan`
✔ Use PowerShell/CMD to avoid Git Bash issues
✔ Commit `terraform.tfstate` securely (or use remote backend)

---
