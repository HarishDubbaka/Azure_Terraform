
# 📘 Terraform Variables Guide

A quick reference for understanding and using **Terraform variables** effectively.  
This guide covers **input variables**, **output variables**, and **local variables**, along with examples and best practices.

---

## 🔹 What Are Variables in Terraform?

Variables are **placeholders for values** that make your Terraform code reusable, flexible, and easier to manage across environments.

- **Input Variables** → Accept values from users or external sources.  
- **Output Variables** → Expose values after deployment (e.g., resource names, IDs).  
- **Local Variables** → Internal computed values to reduce duplication and improve readability.  

---

## 🔹 Primitive Types

- **string** → `"hello world"`  
- **number** → `42`, `3.14`  
- **bool** → `true` / `false`  

---

## 🔹 Complex Types

- **list(type)** → Ordered sequence → `["dev", "stage", "prod"]`  
- **set(type)** → Unique unordered values → `["east", "west"]`  
- **map(type)** → Key-value pairs → `{ region = "us-east-1", instance = "t2.micro" }`  
- **object({})** → Structured attributes  
  ```hcl
  variable "server" {
    type = object({
      name = string
      cpu  = number
      ram  = number
    })
  }
  ```
- **tuple([types])** → Mixed types → `[ "app", 2, true ]`  

---

## 🔹 Defining Input Variables

```hcl
variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "development"
}
```

👉 Think of this as a **box** that stores a text value.  
If no value is provided, Terraform defaults to `"development"`.

---

## 🔹 Using Input Variables

```hcl
tags = {
  environment = var.environment
}
```

- Terraform attaches the variable value as a **tag**.  
- Helps organize resources by environment (dev, stage, prod).  

---

## 🔹 Supplying Input Values

1. **Command-line**  
   ```bash
   terraform plan -var="environment=staging"
   ```
2. **.tfvars file**  
   ```hcl
   environment = "Production"
   ```
   Auto-loaded if named `terraform.tfvars` or `*.auto.tfvars`.  
3. **Environment variable**  
   ```bash
   export TF_VAR_environment="demo"
   terraform plan
   ```

### Precedence Order (highest → lowest)
1. Command-line `-var`  
2. `.tfvars` files  
3. Environment variables (`TF_VAR_`)  
4. Default value  
5. Interactive input  

---

## 🔹 Output Variables

```hcl
output "storage_account_name" {
  value = azurerm_storage_account.example.name
}
```

Retrieve after apply:  
```bash
terraform output storage_account_name
```

---

## 🔹 Local Variables

```hcl
locals {
  common_tags = {
    environment = var.environment
    owner       = "Harish"
    project     = "TerraformDemo"
  }
}
```

- Avoid duplication.  
- Improve readability.  
- Great for **common tags** or repeated values.  

---

## ✅ Best Practices

- Always add **descriptions** for clarity.  
- Use **locals** for repeated values (tags, names).  
- Keep variable names **consistent** across modules.  
- Document variable usage in your README for team visibility.  

---

This README.md is now ready to drop into your **GitHub repo** or share on LinkedIn as part of your Terraform learning journey 🚀.  

Would you like me to also add a **“Risks & Safety Notes” section** (e.g., handling secrets, avoiding hardcoded values) so it aligns with your risk-aware documentation style?
