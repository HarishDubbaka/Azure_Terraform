# 🚀 Blue-Green Deployment on Azure using Terraform

## 📌 Overview

In modern application development, **zero downtime**, **fast rollback**, and **safe releases** are critical.  
**Blue-Green Deployment** is a proven strategy that achieves this by running **two identical environments** and switching traffic between them.

This project demonstrates **Blue-Green Deployment on Azure App Service using Terraform**, following **current AzureRM provider standards** (no deprecated resources).

---

## 🔵🟢 What is Blue-Green Deployment?

Blue-Green Deployment maintains **two production environments**:

### 🔵 Blue Environment
- Current live version
- Serves all production traffic

### 🟢 Green Environment
- New version of the application
- Fully tested before going live

Once the Green environment is validated, traffic is **swapped instantly** from Blue to Green.  
If issues occur, traffic can be switched back to Blue **within seconds**.

---

## ✅ Why Use Blue-Green Deployment?

| Benefit | Description |
|------|------------|
| **Zero Downtime** | Traffic switch happens instantly |
| **Fast Rollback** | Revert to previous version immediately |
| **Safe Testing** | Test in production-like conditions |
| **Reduced Risk** | Known-good version always available |

---

## 🏗️ Azure Implementation Strategy

Azure App Service implements Blue-Green Deployment using:

- **Production Slot (Blue)**
- **Deployment Slot (Green)**

Terraform provisions:
- App Service Plan
- Linux Web App
- Deployment Slot
- Slot Swap capability (manual or automated)

---

## ⚠️ Important: Terraform Resource Validation (Non-Deprecated)

While referring to Terraform documentation, you may find **deprecated resources**.  
This project uses **only supported resources**.

### ❌ Deprecated (Do NOT use)
```hcl
azurerm_app_service
azurerm_app_service_plan
azurerm_app_service_slot
````

These were deprecated in favor of OS-specific resources.

---

### ✅ Correct & Supported Resources (Used Here)

```hcl
azurerm_service_plan
azurerm_linux_web_app
azurerm_linux_web_app_slot
```

📌 **Why S1?**
> Deployment slots are **not supported** in Free or Basic plans.

---

## 🎯 Best Practices

* Use **Standard or Premium SKU**
* Always define explicit dependencies
* Keep Blue environment untouched until validation
* Use slots for zero-downtime CI/CD
* Avoid deprecated Terraform resources

---

## 🧪 Use Cases

* Production deployments
* CI/CD pipelines
* Canary & safe releases
* Rollback-friendly architectures
* Enterprise DevOps practices

---

## 🚀 Conclusion

Blue-Green Deployment using **Azure App Service + Terraform** provides:

* Zero downtime
* Fast rollback
* Safer releases
* Production-grade DevOps automation

This project follows **modern Terraform standards** and avoids deprecated resources, making it **future-proof and interview-ready**.


