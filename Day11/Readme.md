# 📘 Terraform Functions 

Terraform functions are built-in, reusable code blocks that perform specific tasks within Terraform configurations. They make your code more dynamic and ensure your configuration is DRY. Functions allow you to perform various operations, such as converting expressions to different data types, calculating lengths, and building complex variables.


---

## 🔹 What is a Function in Terraform?

Terraform **functions** are built-in utilities that help you transform, calculate, and manipulate data inside your `.tf` configuration files.

Functions keep your Terraform code **clean, dynamic, and reusable** by avoiding hard-coded values.

---

## 🔹 Types of Terraform Functions

| Category            | Description                                                |
| ------------------- | ---------------------------------------------------------- |
| **String**          | Modify or format text (`lower`, `trim`, `format`)          |
| **Numeric**         | Work with numbers (`min`, `max`, `pow`)                    |
| **Collection**      | Manipulate lists, maps, sets (`length`, `merge`, `lookup`) |
| **Date & Time**     | Time-based functions (`timestamp`, `formatdate`)           |
| **Crypto / Hash**   | Hashing functions (`sha256`, `bcrypt`)                     |
| **Filesystem**      | Read files (`file`, `abspath`)                             |
| **IP Network**      | CIDR operations (`cidrhost`, `cidrsubnet`)                 |
| **Encoding**        | Encode/decode (`jsonencode`, `base64encode`)               |
| **Type Conversion** | Convert types (`tostring`, `tomap`, `tolist`)              |

---

## 🔹 How to Test Terraform Functions?

Use the **Terraform Console**:

```sh
terraform console
```

### ✔ Examples

```
> lower("HELLONETWORK")
"hellonetwork"

> max(12, 2, 11)
12

> min(12, 2, 11)
2

> trim("?hello?w", "w")
"?hello?"

> trim("?hello?w", "?w")
"hello"

> chomp("hello\n")
"hello"

> reverse(["a", "b", "c"])
["c", "b", "a"]
```

---

# 🧩 Assignments

---

## ✅ **Assignment 1: Project Naming Convention**

*Functions Used: `lower`, `replace`*

🔹 **Goal**
Convert `"Project ALPHA Resource"` → `"project-alpha-resource"`

### Variables

```hcl
variable "project_name" {
  description = "The name of the resource group"
  type        = string
  default     = "Project ALPHA Resource"
}

variable "allowed_locations" {
  type    = list(string)
  default = ["East US", "West Europe", "South India"]
}
```

### Locals

```hcl
locals {
  transformed_name = replace(lower(var.project_name), " ", "-")
}
```

### Resource Group

```hcl
resource "azurerm_resource_group" "example" {
  name     = local.transformed_name
  location = var.allowed_locations[1]
}
```

### Output

```hcl
output "resource_group_name" {
  value = azurerm_resource_group.example.name
}
```

### ✔ Output

```
resource_group_name = "project-alpha-resource"
```

---

## ✅ **Assignment 2: Resource Tagging**

*Function Used: `merge`*

🔹 **Goal**
Combine default tags and environment tags.

### Variables

```hcl
variable "default_tags" {
  type = map(string)
  default = {
    project = "terraform"
    owner   = "harish"
  }
}

variable "environment_tags" {
  type = map(string)
  default = {
    environment = "dev"
    team        = "cloud"
  }
}
```

### Locals

```hcl
locals {
  transformed_name = replace(lower(var.project_name), " ", "-")
  merged_tags      = merge(var.default_tags, var.environment_tags)
}
```

### Resource Group

```hcl
resource "azurerm_resource_group" "example" {
  name     = local.transformed_name
  location = var.allowed_locations[1]

  tags = local.merged_tags
}
```

### ✔ Expected Output

```
tags = {
  project     = "terraform"
  owner       = "harish"
  environment = "dev"
  team        = "cloud"
}
```

---

# ⚠️ Important

Always **destroy unused resources** after testing Terraform code:

```sh
terraform destroy --auto-approve
```

Cloud resources cost money — don’t forget to clean up!

---

