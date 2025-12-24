# Terraform Provisioners – Complete Guide

## Introduction

Automation is the foremost requirement of any cloud-oriented activity. As the chief tool for Infrastructure as Code (IaC), **Terraform** enables teams to automate infrastructure provisioning in a clean and repeatable way.

However, provisioning infrastructure alone is not always sufficient. Often, servers require **post-deployment configuration**, software installation, or custom setup steps. This is where **Terraform Provisioners** come into play.

Provisioners allow execution of scripts or commands on local or remote machines during resource creation or destruction. While powerful, HashiCorp recommends using provisioners **sparingly**, preferring tools like **cloud-init** or **configuration management systems (Ansible, Chef, Puppet)** for long-term configuration management.

This guide explains:

* What Terraform provisioners are
* Types of provisioners
* How to use them with examples
* When and why they should be used as a last resort

---

## What are Provisioners in Terraform?

Provisioners in Terraform are mechanisms that allow execution of scripts or commands on resources during:

* **Creation** (`apply`)
* **Destruction** (`destroy`)

They are commonly used for:

* Installing software
* Copying configuration files
* Running setup scripts
* Performing one-time initialization tasks

Provisioners extend Terraform’s capabilities beyond infrastructure provisioning, but they are considered a **last-resort solution** due to reliability, idempotency, and state-tracking concerns.

---

## How to Use Terraform Provisioners

Provisioners are defined inside a `resource` block using the `provisioner` keyword.

Terraform supports multiple types of provisioners. The most commonly used are:

* **file** – Copy files or directories to a remote resource
* **local-exec** – Execute commands on the machine running Terraform
* **remote-exec** – Execute commands on the remote resource (e.g., VM)

> ⚠️ **Best Practice:** Use provisioners only when native Terraform resources, cloud-init, or configuration management tools cannot achieve the required configuration.

---

## Types of Terraform Provisioners

### 1. File Provisioner

The `file` provisioner copies files or directories from the local machine to a remote resource.

```hcl
provisioner "file" {
  source      = "configs/sample.conf"
  destination = "/home/azureuser/sample.conf"

  connection {
    type     = "ssh"
    user     = "azureuser"
    password = var.vm_password
    host     = azurerm_public_ip.vm_ip.ip_address
  }
}
```

**Use cases:**

* Copy configuration files
* Upload scripts for later execution

---

### 2. Local-Exec Provisioner (Pre-deployment)

The `local-exec` provisioner runs commands on the **local system** where Terraform is executed.

```hcl
resource "null_resource" "deployment_prep" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo 'Deployment started at ${timestamp()}' > deployment-${timestamp()}.log"
  }
}
```

**Key points:**

* Runs locally before or after resource creation
* Useful for logging, notifications, or CI/CD integration
* Commonly paired with `null_resource`

---

### 3. Remote-Exec Provisioner

The `remote-exec` provisioner executes commands directly on the remote resource after it is created.

```hcl
provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y nginx",
    "echo '<html><body><h1>#28daysofAZTerraform is Awesome!</h1></body></html>' | sudo tee /var/www/html/index.html",
    "sudo systemctl start nginx",
    "sudo systemctl enable nginx"
  ]

  connection {
    type     = "ssh"
    user     = "azureuser"
    password = var.vm_password
    host     = azurerm_public_ip.vm_ip.ip_address
  }
}
```

**Use cases:**

* Install packages
* Configure services
* Run initialization scripts

---

## Why Provisioners Should Be a Last Resort

Although provisioners are powerful, they come with important limitations:

* ❌ **Lack of state tracking** – Terraform cannot track what provisioners change
* ❌ **Non-idempotent** – Re-running may produce inconsistent results
* ❌ **Hard to debug** – Failures can be environment-specific
* ❌ **Tight coupling** – Infrastructure and configuration become intertwined

Provisioners provide unrestricted OS-level access, which introduces operational risk and maintenance complexity.

### Recommended Alternatives

* **cloud-init / user_data** – Best for VM bootstrapping
* **Ansible** – Preferred for configuration management
* **Packer** – Pre-bake VM images
* **Native Terraform resources** – Always preferred when available

---

## When to Use Terraform Provisioners

Use provisioners only when:

* A required action is not supported by Terraform providers
* The task is a **one-time initialization**
* You fully understand the risks and limitations

---

## Conclusion

Terraform provisioners enable post-deployment automation when no other options are available. While they are useful for quick setups and edge cases, relying on them heavily can lead to brittle and hard-to-maintain infrastructure.

👉 **Rule of thumb:** Use provisioners only as a last resort and prefer declarative, idempotent tools whenever possible.

---

Happy Automating 🚀
