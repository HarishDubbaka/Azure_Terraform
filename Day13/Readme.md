# 📘 Terraform Data Sources 

Terraform is an **Infrastructure as Code (IaC)** tool that allows you to define, provision, and manage cloud infrastructure using code. While Terraform is commonly used to **create and manage resources**, there are many scenarios where you only need to **read information about existing infrastructure**.
This is where **Terraform Data Sources** come into play.

---

## 🔹 What is a Data Source in Terraform?

Data sources in Terraform allow you to dynamically retrieve information about existing infrastructure, whether it is managed within Terraform or provisioned externally.

Data sources enable Terraform configurations to reference real-time data about cloud resources, services, or other dependencies without directly creating or modifying them. This is particularly useful when integrating Terraform with pre-existing environments, reusing shared infrastructure components, or querying dynamic attributes that may change over time.

By leveraging data sources, you can ensure your configurations remain flexible, adaptable, and aligned with the current state of your infrastructure.

These resources may be:

* Created manually
* Managed by another Terraform configuration
* Provisioned using other tools like Ansible or ARM templates

👉 Data sources are **read-only** and help Terraform stay aligned with real infrastructure.

### Example

```hcl
data "azurerm_resource_group" "existing" {
  name = "shared-resource-group"
}
```

Terraform reads the resource group but does **not manage it**.

---

## 🔹 Variables vs Data Sources in Terraform

Terraform variables and data sources serve different purposes within the infrastructure provisioning workflow.

Variables are used to parameterise your Terraform configurations, they allow you to define reusable values. This allows you to configure different environments easily by having a centralised place where you can change values easily.

Data sources are used to retrieve information that you can incorporate into your configuration. Data sources query for information they don’t change or move resources under Terraform management.


### Terraform Variables

* Used to **parameterize configurations**
* Values are **provided by users**
* Help reuse the same code across environments

```hcl
variable "location" {
  default = "eastus"
}
```

### Terraform Data Sources

* Used to **fetch real infrastructure data**
* Values come from **cloud providers**
* Read-only, no lifecycle management

```hcl
data "azurerm_virtual_network" "existing_vnet" {
  name                = "shared-vnet"
  resource_group_name = "network-rg"
}
```

---

## 🔹 Datasources vs Resources

| Feature    | Resources                  | Datasources                    |
| ---------- | -------------------------- | ------------------------------ |
| Purpose    | Create / Update / Delete   | Read existing infrastructure   |
| Keyword    | `resource`                 | `data`                         |
| Management | Fully managed by Terraform | Read-only reference            |
| Examples   | VM, Storage Account, VNet  | Existing RG, VNet, Subnet, AMI |

---

## 🔹 Why Use Datasources?

There are several practical reasons to leverage datasources:

* Cross-environment integration: You may want to link different layers of your infrastructure (e.g., backend database created in one module and frontend in another).

* Access existing resources: Resources created via Ansible, CloudFormation, or manual provisioning can be read and utilized.

* Reduce duplication: Instead of hardcoding values or duplicating configuration, use datasources to dynamically fetch the latest information.

In short, datasources make Terraform more modular, flexible, and reliable.

### Common Use Cases

* 🔗 **Cross-environment integration**
  (e.g., use a shared VNet created by another team)
* ♻️ **Reuse existing infrastructure**
* 🧩 **Modular architecture**
* ❌ Avoid hardcoding values

---

## 🔹 When to Use Datasources

✅ Use datasources when:

* Infrastructure already exists
* Resources are managed outside Terraform
* You need real-time values
* Sharing infrastructure across modules or teams

🚫 Avoid datasources when:

* Terraform should manage the lifecycle
* The external resource is unstable or unreliable

---

## 🔹 Practical Example (Azure)

```hcl
data "azurerm_resource_group" "shared" {
  name = "Shared-RG"
}

data "azurerm_virtual_network" "shared_vnet" {
  name                = "shared-network"
  resource_group_name = data.azurerm_resource_group.shared.name
}
```

✔ Terraform **reads** the resource group and VNet
❌ Terraform does **not** create or modify them

---

## 🔹 Best Practices

* Keep data sources **read-only**
* Avoid circular dependencies
* Use data sources for **shared infrastructure**
* Prefer outputs + data sources in multi-module setups

---

## ⚠️ Important Reminder

> 🛑 **Always destroy unused infrastructure**
> Cloud resources incur costs if left running.
> Use:

```bash
terraform destroy
```

---

## 🎯 Conclusion

Terraform data sources are essential for:

* Integrating existing infrastructure
* Reducing duplication
* Building scalable, modular architectures
* Preventing configuration drift

They bridge the gap between **managed** and **unmanaged** resources, making Terraform projects more powerful and production-ready.

---
