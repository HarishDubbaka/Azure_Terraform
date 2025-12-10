# Terraform: Dynamic Blocks, Conditional Expressions & Splat Expressions

A Practical Guide for Cleaner, Scalable IaC

Infrastructure as Code (IaC) can get messy when your configurations grow. Dynamic blocks, conditional expressions, and splat expressions help you write **clean, reusable, scalable Terraform code** with fewer mistakes.

This guide demonstrates all three concepts with clear examples.

---

## 🚀 1. Dynamic Blocks — Generate Nested Blocks Automatically

Dynamic blocks in Terraform automate repetitive tasks, making your code simpler to manage. Instead of copying and pasting similar blocks over and over, dynamic blocks allow you to loop through a set of values (like a list or map) and automatically generate the necessary configurations.

Dynamic blocks are used exclusively within resource blocks, allowing you to dynamically generate multiple nested configurations inside a resource.

Think of them like a programming for loop. You define a template, and Terraform loops through the data, applying the same logic across multiple resources.

This makes dynamic blocks especially useful for configurations that scale, such as security group rules or multiple instances.

Key parts of a dynamic block
for_each: Tells Terraform how many times to repeat the block. It loops through a collection (like a list or map) and creates a block for each entry. for_each iterates over a collection, generating one instance of the content block per item, making it particularly useful for handling multiple resources efficiently.
content: Defines the structure of each block. It’s the template Terraform uses during each loop
nsg_rules: A list of objects where each object defines parameters such as priority,ports,protocol.


### **🔹 Use Case Example: Creating Multiple NSG Rules**

**locals.tf**

```hcl
locals {
  nsg_rules = {
    "allow_http" = {
      priority               = 100
      destination_port_range = "80"
      description            = "Allow HTTP"
    },
    "allow_https" = {
      priority               = 110
      destination_port_range = "443"
      description            = "Allow HTTPS"
    }
  }
}
```

**main.tf**

```hcl
resource "azurerm_network_security_group" "example" {
  name                = "harish-nsg"
  location            = var.allowed_locations[1]
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                        = security_rule.key
      priority                    = security_rule.value.priority
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = security_rule.value.destination_port_range
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      description                 = security_rule.value.description
    }
  }
}
```
In this example, Terraform dynamically generates the security nsg_rules based on the local.tf variable. By looping through the list of rules, Terraform applies the configuration for each one, reducing manual repetition and keeping your code consistent.

This is particularly useful when managing complex infrastructure where the same logic applies to multiple resources.

### ✅ Why this is useful?

* No repeated code
* Easy to scale with new rules
* Updates only in one place

---

## 🎯 2. Conditional Expressions — Making Decisions in Terraform

Terraform uses conditional expressions to select one of two values based on a conditions. This is similar to the ternary operator in other programming languages.

```hcl
Syntax
condition ? value_if_true : value_if_false
```
If the condition is true, the expression evaluates to true_val; otherwise, it evaluates to false_val.

### **Example: Changing NSG Name per Environment**

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

resource "azurerm_network_security_group" "example" {
  name                = var.environment == "dev" ? "dev-nsg" : "stage-nsg"
  location            = var.allowed_locations[1]
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                        = security_rule.key
      priority                    = security_rule.value.priority
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = security_rule.value.destination_port_range
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      description                 = security_rule.value.description
    }
  }
}
```

### ✅ Useful for:

* Creating different resources per environment
* Switching configuration values dynamically

---

## 📌 3. Splat Expressions — Extracting Values from Collections

Splat expressions in Terraform provide a concise way to perform operations on lists, sets, and tuples. They are particularly useful for accessing attributes of elements within these collections.

Splat expressions simplify retrieving attributes from multiple resource instances created using count or for_each.

### **Example: Output All NSG Rule Objects**

```hcl
output "splatted_rgname" {
  value = local.nsg_rules[*]
}
```

### More Examples

Extract only rule names:

```hcl
output "rule_names" {
  value = [for rule in local.nsg_rules : rule.description]
}
```

---

## 📘 Summary

| Feature                     | Purpose                                   | Best Use Case                         |
| --------------------------- | ----------------------------------------- | ------------------------------------- |
| **Dynamic Blocks**          | Auto-generate nested blocks               | NSG rules, tags, IP configs           |
| **Conditional Expressions** | Change resource config based on condition | Dev vs Prod naming, optional features |
| **Splat Expressions**       | Extract values from lists/maps            | Outputs, loops, dependencies          |

Terraform becomes much more powerful and cleaner when you master these expressions.
These patterns reduce repetition, avoid human errors, and keep your IaC scalable.

---
### ⚠️ IMPORTANT: Destroy Resources After Testing

Terraform-created cloud resources continue costing money until you remove them.
After finishing your test or demo:

```hcl
terraform destroy --auto-approve
```
This ensures:

No accidental Azure billing

No leftover NSGs, NICs, VMs, or Resource Groups

Clean Terraform state for future runs

👉 Always run destroy if the infrastructure is no longer needed.

