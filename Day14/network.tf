############################################
# RESOURCE GROUP
############################################
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.allowed_locations[2]
}

############################################
# VIRTUAL NETWORK
############################################
resource "azurerm_virtual_network" "vnet" {
  name                = "dubbaka-Vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

############################################
# SUBNET
############################################
resource "azurerm_subnet" "subnet" {
  name                 = "dubbaka-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/20"]
}

############################################
# NETWORK SECURITY GROUP
############################################
resource "azurerm_network_security_group" "nsg" {
  name                = "dubbaka-NSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = security_rule.value.description
    }
  }
}


############################################
# NSG → SUBNET ASSOCIATION
############################################
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


############################################
# PUBLIC IP FOR LOAD BALANCER
############################################
resource "azurerm_public_ip" "publicip" {
  name                = "dubbaka-PublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  domain_name_label = "dubbaka-lb-${random_pet.lb_hostname.id}"

}
resource "random_pet" "lb_hostname" {
}

############################################
# LOAD BALANCER
############################################
resource "azurerm_lb" "lb" {
  name                = "dubbaka-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  name            = "dubbaka-bckendpol"
  loadbalancer_id = azurerm_lb.lb.id
}

############################################
# LOAD BALANCER PROBE
############################################
resource "azurerm_lb_probe" "probe" {
  name                = "dubbaka-lbprobe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Http"
  port                = 80
  interval_in_seconds = 15
  number_of_probes    = 2
  request_path        = "/"
}

############################################
# LOAD BALANCER RULE
############################################
resource "azurerm_lb_rule" "lbrule" {
  name                           = "dubbaka-lbrule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
  probe_id                       = azurerm_lb_probe.probe.id
}

############################################
# LB NAT RULE FOR SSH
############################################
resource "azurerm_lb_nat_rule" "ssh" {
  name                           = "ssh-nat"
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"

  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22

  frontend_ip_configuration_name = "PublicIPAddress"

  # ✅ THIS IS THE MISSING LINE (ADD HERE)
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bepool.id
}





############################################
# NAT GATEWAY PUBLIC IP
############################################
resource "azurerm_public_ip" "natgwpip" {
  name                = "natgw-publicip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

############################################
# NAT GATEWAY
############################################
resource "azurerm_nat_gateway" "natgw" {
  name                    = "nat-gateway"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}


############################################
# NAT GATEWAY → SUBNET ASSOCIATION
############################################
resource "azurerm_subnet_nat_gateway_association" "nat_assoc" {
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}

############################################
# NAT GATEWAY → PUBLIC IP ASSOCIATION
############################################
resource "azurerm_nat_gateway_public_ip_association" "natgw_ip_assoc" {
  public_ip_address_id = azurerm_public_ip.natgwpip.id
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
}
