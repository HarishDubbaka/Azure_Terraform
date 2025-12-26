# 📘 Azure Policy as Code (PaC) using Terraform

## 🧩 Scenario

Imagine a scenario where your organization requires all Azure Resource Groups to have a **mandatory `env` tag**. Managing these policies manually across multiple subscriptions and management groups is **time-consuming and prone to human error**.

This is where **Policy as Code (PaC)** comes into play.

---

## 🛠️ What is Policy as Code?

With **Policy as Code**, you can define, manage, and enforce Azure policies **programmatically using Terraform**.

Today, we focus on creating **Azure Policy Definitions at the management group level using Terraform**.

---

## 📌 Objectives

* Define the policy use case
* Write Terraform configurations for policy definitions
* Deploy the policies in Azure

---

## ❓ Why Policy as Code?

Organizations often enforce policies to ensure:

* Compliance
* Security
* Best practices across cloud resources

**Azure Policy Definitions** allow you to enforce such rules, ensuring resources are:

* Tagged correctly
* Restricted to approved configurations
* Governed as per organizational standards

---

## 🧪 Use Case Example

We need to enforce policies that ensure:

### ✅ Mandatory Tags on Resource Groups

* `department`
* `project`

### ✅ Allowed Locations

* South India
* East US

### ✅ Allowed VM Sizes

* `Standard_B2s`
* `Standard_B2ms`

🚫 If a Resource Group or resource is missing **any of these defined values**, Azure will **deny its creation**.

---

## 🧾 Example: Location Governance Policy

```hcl
########################################
# 3️⃣ LOCATION GOVERNANCE POLICY
########################################
resource "azurerm_policy_definition" "location" {
  name         = "allowed-locations-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Locations Policy"

  policy_rule = jsonencode({
    if = {
      not = {
        field = "location"
        in    = var.location
      }
    }
    then = {
      effect = "Deny"
    }
  })
}
```

### Policy Assignment

```hcl
resource "azurerm_subscription_policy_assignment" "location_assignment" {
  name                 = "location-assignment"
  policy_definition_id = azurerm_policy_definition.location.id
  subscription_id      = data.azurerm_subscription.current.id
}
```

---

## ⚠️ Important Implementation Note

While implementing the policies:

> **First apply the policy, then create the resources.**

This ensures governance rules are enforced **before any infrastructure is provisioned**.

---

## ✅ Conclusion

Policy as Code enables organizations to treat **governance like infrastructure**:

* Version-controlled
* Automated
* Scalable
* Reliable

Using **Terraform + Azure Policy**, cloud governance becomes **consistent and enforceable across environments**.

---

