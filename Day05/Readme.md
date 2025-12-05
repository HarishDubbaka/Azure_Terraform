


# 📘  What are Terraform Variables?

Terraform variables allow you to insert values in Terraform configuration files. They are used to store and manipulate data, such as IP addresses, usernames, and passwords. 
They can be assigned a value, which can then be changed or used as is in the configuration execution.
Using variables, you can easily customize and reuse Terraform code without hardcoding specific values directly into your infrastructure setup.
This flexibility allows for seamless adjustments to different environments or resource requirements by modifying the assigned terraform variables value.

# 📘 Terraform Variables Guide

A quick reference for understanding and using **Terraform variables** effectively.  
Broadly, Terraform variables can be categorized into two primary types: input variables and output variables.

---

## 🔹 What Are Variables in Terraform?

Variables are **placeholders for values** that make your Terraform code reusable, flexible, and easier to manage across environments.

- **Input Variables** → These are used to receive values from the user, the environment, or external sources during the Terraform execution. They act as parameters to your Terraform configuration..  
- **Output Variables** → These are used to expose values derived from your infrastructure deployment. They allow you to retrieve information about the provisioned resources and use them in other applications or systems.  
- **Local Variables** → Terraform Locals are named values which can be assigned and used in your code. It mainly serves the purpose of reducing duplication within the Terraform code. When you use Locals in the code, since you are reducing duplication of the same value, you also increase the readability of the code.  


Terraform input variables are categorized into **primitive types** and **complex types**. Let me break them down clearly:
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

## ✅ Best Practices for Using Terraform Variables


Use meaningful variable names → Clearly indicate the variable’s purpose.
Provide clear descriptions → Explain the role and usage of each variable.
Set appropriate data types → Ensure data integrity and prevent errors.
Define default values → Simplify configuration and reduce manual input.
Implement validation rules → Enforce constraints and prevent invalid configurations.
Mark sensitive variables as sensitive → Protect secrets like passwords and API keys.
Organize variables into logical groups → Use separate files (e.g., network.tfvars, compute.tfvars).
Document your variables thoroughly → Help teams understand usage and configuration.
Use modules effectively → Make infrastructure reusable and adaptable.

---

