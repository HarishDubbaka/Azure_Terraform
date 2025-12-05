Here is your **clean, professional, and repo-ready `README.md`** created using the content you provided 👇

---

# 📘 Terraform Variables Guide

Terraform variables allow you to insert flexible, reusable values into your Terraform configurations. Instead of hardcoding values like IPs, usernames, regions, or environment names, variables let you **customize infrastructure deployments** without modifying your main code.

They help you:

* Reuse the same code across environments
* Improve readability
* Maintain cleaner and more modular infrastructure

---

# 🔹 Types of Terraform Variables

Terraform variables fall into three main categories:

---

## 1️⃣ **Input Variables**

Used to **provide values** to your Terraform configuration.
These values can come from users, `.tfvars` files, or environment variables.

---

## 2️⃣ **Output Variables**

Used to **expose values** after an infrastructure deployment.
Helpful when passing data to other tools or displaying important outputs.

---

## 3️⃣ **Local Variables**

Used internally within Terraform to:

* Remove duplication
* Improve readability
* Store computed values

---

# 🔹 Primitive Variable Types

| Type     | Description   | Example         |
| -------- | ------------- | --------------- |
| `string` | Text value    | `"hello world"` |
| `number` | Numeric value | `42`, `3.14`    |
| `bool`   | True/false    | `true`          |

---

# 🔹 Complex Variable Types

| Type             | Description               | Example                                    |
| ---------------- | ------------------------- | ------------------------------------------ |
| `list(type)`     | Ordered list of same type | `["dev", "stage", "prod"]`                 |
| `set(type)`      | Unique unordered values   | `["east", "west"]`                         |
| `map(type)`      | Key/value pairs           | `{ region = "us-east-1", size = "small" }` |
| `object({})`     | Named attributes          | See below                                  |
| `tuple([types])` | Mixed-value ordered list  | `["app", 2, true]`                         |

### Example of `object` type:

```hcl
variable "server" {
  type = object({
    name = string
    cpu  = number
    ram  = number
  })
}
```

---

# 🔹 Defining Input Variables

Example variable:

```hcl
variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "development"
}
```

This defines:

* A variable named **environment**
* Accepts a **string**
* Defaults to `"development"` if nothing is provided

---

# 🔹 Using Input Variables

```hcl
tags = {
  environment = var.environment
}
```

> Terraform reads the value of `var.environment` and applies it as a tag.

---

# 🔹 Providing Values to Variables

### ✔️ 1. Command Line

```bash
terraform plan -var="environment=staging"
```

### ✔️ 2. `.tfvars` File

`terraform.tfvars`:

```hcl
environment = "Production"
```

Auto-loaded by Terraform.

### ✔️ 3. Environment Variables

```bash
export TF_VAR_environment="demo"
terraform plan
```

---

# 🔹 Variable Precedence (Highest → Lowest)

1. Command-line `-var`
2. `.tfvars` / `*.auto.tfvars`
3. Environment variables (`TF_VAR_`)
4. Default value in variable block
5. Interactive input

---

# 🔹 Output Variables

```hcl
output "storage_account_name" {
  value = azurerm_storage_account.example.name
}
```

Retrieve value:

```bash
terraform output storage_account_name
```

---

# 🔹 Local Variables

```hcl
locals {
  common_tags = {
    environment = var.environment
    owner       = "Harish"
    project     = "TerraformDemo"
  }
}
```

Local variables help reduce repetition and keep configurations clean.

---

# ✅ Best Practices for Terraform Variables

* Use **meaningful names**
* Provide **clear descriptions**
* Define **types** to prevent invalid inputs
* Use **default values** when possible
* Apply **validation rules**
* Mark secrets as **sensitive**
* Group variables into logical files
* Document variables in `README.md`
* Use modules for reusability

---

If you want, I can also:

✅ Add diagrams
✅ Add examples for each variable type
✅ Convert this into a GitHub-ready **Terraform Basics Folder Structure**

Just tell me!
