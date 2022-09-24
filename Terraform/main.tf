# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "main" {
    name = "Azuredevops"
}

# Create a virtual network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags = {
      env : var.prefix
  }
}

# Create a subnet
resource "azurerm_subnet" "main" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a NSG
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags = {
      env : var.prefix
  }  
}

# Create rule to deny traffic from internet
resource "azurerm_network_security_rule" "mainsr100" {
  name                        = "DenyVNetInboundFromInternet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Create a NIC
resource "azurerm_network_interface" "main" {
  count               = var.vm_count
  name                = "${var.prefix}-${count.index}-nic"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  tags = {
      env : var.prefix
  }

  ip_configuration {
    name                          = "${var.prefix}-${count.index}-ip-configuration"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }  
}

# Add public IP
resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-public-ip"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = "Static"
  tags = {
      env : var.prefix
  }  
}

# Create load balancer
resource "azurerm_lb" "main" {
  name                = "${var.prefix}-load-balancer"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags = {
      env : var.prefix
  }

  frontend_ip_configuration {
    name                 = "${var.prefix}-public-ip"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}


resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${var.prefix}-backend-address-pool"
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.vm_count
  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = azurerm_network_interface.main[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_availability_set" "main" {
  name                         = "${var.prefix}-vm-availability-set"
  resource_group_name          = data.azurerm_resource_group.main.name
  location                     = data.azurerm_resource_group.main.location
  platform_update_domain_count = var.vm_count
  platform_fault_domain_count  = var.vm_count
  tags = {
      env : var.prefix
  }  
}

# Use my custom Packer image
data "azurerm_image" "main" {
  name                = "projectImage"
  resource_group_name = data.azurerm_resource_group.main.name
}

# Create VMs
resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.vm_count
  name                            = "${var.prefix}-${count.index}-vm"
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  size                            = "Standard_B1s"
  source_image_id                 = data.azurerm_image.main.id
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  availability_set_id             = azurerm_availability_set.main.id
  tags = {
      env : var.prefix
  }

  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
  ]

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

resource "azurerm_managed_disk" "main" {
  count                = var.vm_count
  name                 = "${var.prefix}-${count.index}-manged-disk"
  location             = data.azurerm_resource_group.main.location
  resource_group_name  = data.azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
  tags = {
      env : var.prefix
  }  
}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  count              = var.vm_count
  managed_disk_id    = azurerm_managed_disk.main[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.main[count.index].id
  lun                = "1"
  caching            = "ReadWrite"
}

resource "azurerm_lb_probe" "main" {
  name            = "${var.prefix}-lb-probe"
  loadbalancer_id = azurerm_lb.main.id
  port            = 80
}

resource "azurerm_lb_rule" "main" {
  name                           = "${var.prefix}-lb-rule-http"
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  frontend_ip_configuration_name = azurerm_lb.main.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.main.id
}
