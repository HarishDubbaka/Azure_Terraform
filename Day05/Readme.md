# 📘  Terraform Variables

Terraform variables allow you to insert values in Terraform configuration files. They are used to store and manipulate data, such as IP addresses, usernames, and passwords. 
They can be assigned a value, which can then be changed or used as is in the configuration execution.
Using variables, you can easily customize and reuse Terraform code without hardcoding specific values directly into your infrastructure setup.
This flexibility allows for seamless adjustments to different environments or resource requirements by modifying the assigned terraform variables value.

# Terraform Variables Guide

![Image Alt](https://github.com/HarishDubbaka/Azure_Terraform/blob/63e8cdeaef48eed2f52dea41c305130c2c5082c0/Day05/variables.jpg)

A quick reference for understanding and using **Terraform variables** effectively.  


---

# 🔹 Types of Terraform Variables

Terraform variables fall into three main categories:

---

## 1️⃣ **Input Variables**

- **Input Variables** → These are used to receive values from the user, the environment, or external sources during the Terraform execution. They act as parameters to your Terraform configuration..
These values can come from users, `.tfvars` files, or environment variables.

---
Terraform input variables are categorized into **primitive types** and **complex types**. Let me break them down clearly:
---

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

![Image Alt](https://github.com/HarishDubbaka/Azure_Terraform/blob/63e8cdeaef48eed2f52dea41c305130c2c5082c0/Day05/presidence.png)

1. Command-line `-var`
2. `.tfvars` / `*.auto.tfvars`
3. Environment variables (`TF_VAR_`)
4. Default value in variable block
5. Interactive input


---

## 2️⃣ **Output Variables**

- **Output Variables** → These are used to expose values derived from your infrastructure deployment. They allow you to retrieve information about the provisioned resources and use them in other applications or systems.
  
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


## 3️⃣ **Local Variables**

- **Local Variables** → Terraform Locals are named values which can be assigned and used in your code. It mainly serves the purpose of reducing duplication within the Terraform code. When you use Locals in the code, since you are reducing duplication of the same value, you also increase the readability of the code.  

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

## ✅ Best Practices for Using Terraform Variables


* Use meaningful variable names → Clearly indicate the variable’s purpose.
* Provide clear descriptions → Explain the role and usage of each variable.
* Set appropriate data types → Ensure data integrity and prevent errors.
* Define default values → Simplify configuration and reduce manual input.
* Implement validation rules → Enforce constraints and prevent invalid configurations.
* Mark sensitive variables as sensitive → Protect secrets like passwords and API keys.
* Organize variables into logical groups → Use separate files (e.g., network.tfvars, compute.tfvars).
* Document your variables thoroughly → Help teams understand usage and configuration.
* Use modules effectively → Make infrastructure reusable and adaptable.

---

