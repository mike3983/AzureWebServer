# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
This is a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions

**1. Log into MS Azure**
```bash 
az login
```

Make note of the `id` field as this is your subscription_id

Save your credentials as the following envionment variables
```bash
export ARM_CLIENT_ID=<YOUR CLIENT ID>
export ARM_CLIENT_SECRET=<YOUR CLIENT SECRET>
export ARM_SUBSCRIPTION_ID=<YOUR SUBSCRIPTION ID>
export ARM_TENANT_ID=<YOUR TENANT ID>
```
**2. Build server image using Packer**

Once in the working directory, run the command `packer init`

Packer will exit without any output. It is ready to build the image.

Build the image using the command `packer build server.json`

Note: you can verify the image using the command `az image list`

**2. Create resources including load balancer using Terraform**
1. `cd` to the Terraform folder
2. Run `terraform init` to initialise Terraform
3. Run `terraform plan -out solution.plan` to view what will be created
4. Run `terraform apply` to build the web server and load balancer


### How to customise the vars.tf file

Vars.tf includes several variables, all with default values. You can customise the default values for any of these fields, simply edit relavant 'default' value.   

### Output
Here is the expected output from running `terraform apply`:

$ terraform apply
var.password
  password for VMs

  Enter a value: WordPass@@31

var.username
  username for VMs

  Enter a value: mikeg

data.azurerm_resource_group.main: Reading...
data.azurerm_resource_group.main: Read complete after 0s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops]
data.azurerm_image.main: Reading...
data.azurerm_image.main: Read complete after 0s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/projectImage]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_availability_set.main will be created
  + resource "azurerm_availability_set" "main" {
      + id                           = (known after apply)
      + location                     = "eastus"
      + managed                      = true
      + name                         = "AzureWebServerMG-vm-availability-set"
      + platform_fault_domain_count  = 2
      + platform_update_domain_count = 2
      + resource_group_name          = "Azuredevops"
      + tags                         = {
          + "env" = "AzureWebServerMG"
        }
    }

  # azurerm_lb.main will be created
  + resource "azurerm_lb" "main" {
      + id                   = (known after apply)
      + location             = "eastus"
      + name                 = "AzureWebServerMG-load-balancer"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "Azuredevops"
      + sku                  = "Basic"
      + sku_tier             = "Regional"
      + tags                 = {
          + "env" = "AzureWebServerMG"
        }

      + frontend_ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + id                                                 = (known after apply)
          + inbound_nat_rules                                  = (known after apply)
          + load_balancer_rules                                = (known after apply)
          + name                                               = "AzureWebServerMG-public-ip"
          + outbound_rules                                     = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = (known after apply)
          + private_ip_address_version                         = (known after apply)
          + public_ip_address_id                               = (known after apply)
          + public_ip_prefix_id                                = (known after apply)
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_lb_backend_address_pool.main will be created
  + resource "azurerm_lb_backend_address_pool" "main" {
      + backend_ip_configurations = (known after apply)
      + id                        = (known after apply)
      + load_balancing_rules      = (known after apply)
      + loadbalancer_id           = (known after apply)
      + name                      = "AzureWebServerMG-backend-address-pool"
      + outbound_rules            = (known after apply)
    }

  # azurerm_lb_probe.main will be created
  + resource "azurerm_lb_probe" "main" {
      + id                  = (known after apply)
      + interval_in_seconds = 15
      + load_balancer_rules = (known after apply)
      + loadbalancer_id     = (known after apply)
      + name                = "AzureWebServerMG-lb-probe"
      + number_of_probes    = 2
      + port                = 80
      + protocol            = (known after apply)
    }

  # azurerm_lb_rule.main will be created
  + resource "azurerm_lb_rule" "main" {
      + backend_address_pool_ids       = (known after apply)
      + backend_port                   = 80
      + disable_outbound_snat          = false
      + enable_floating_ip             = false
      + frontend_ip_configuration_id   = (known after apply)
      + frontend_ip_configuration_name = "AzureWebServerMG-public-ip"
      + frontend_port                  = 80
      + id                             = (known after apply)
      + idle_timeout_in_minutes        = (known after apply)
      + load_distribution              = (known after apply)
      + loadbalancer_id                = (known after apply)
      + name                           = "AzureWebServerMG-lb-rule-http"
      + probe_id                       = (known after apply)
      + protocol                       = "Tcp"
    }

  # azurerm_linux_virtual_machine.main[0] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                  = (sensitive value)
      + admin_username                  = "mikeg"
      + allow_extension_operations      = true
      + availability_set_id             = (known after apply)
      + computer_name                   = (known after apply)
      + disable_password_authentication = false
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "eastus"
      + max_bid_price                   = -1
      + name                            = "AzureWebServerMG-0-vm"
      + network_interface_ids           = (known after apply)
      + patch_mode                      = "ImageDefault"
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "Azuredevops"
      + size                            = "Standard_B1s"
      + source_image_id                 = "/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/projectImage"
      + tags                            = {
          + "env" = "AzureWebServerMG"
        }
      + virtual_machine_id              = (known after apply)

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + termination_notification {
          + enabled = (known after apply)
          + timeout = (known after apply)
        }
    }

  # azurerm_linux_virtual_machine.main[1] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                  = (sensitive value)
      + admin_username                  = "mikeg"
      + allow_extension_operations      = true
      + availability_set_id             = (known after apply)
      + computer_name                   = (known after apply)
      + disable_password_authentication = false
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "eastus"
      + max_bid_price                   = -1
      + name                            = "AzureWebServerMG-1-vm"
      + network_interface_ids           = (known after apply)
      + patch_mode                      = "ImageDefault"
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "Azuredevops"
      + size                            = "Standard_B1s"
      + source_image_id                 = "/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/projectImage"
      + tags                            = {
          + "env" = "AzureWebServerMG"
        }
      + virtual_machine_id              = (known after apply)

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + termination_notification {
          + enabled = (known after apply)
          + timeout = (known after apply)
        }
    }

  # azurerm_managed_disk.main[0] will be created
  + resource "azurerm_managed_disk" "main" {
      + create_option                 = "Empty"
      + disk_iops_read_only           = (known after apply)
      + disk_iops_read_write          = (known after apply)
      + disk_mbps_read_only           = (known after apply)
      + disk_mbps_read_write          = (known after apply)
      + disk_size_gb                  = 1
      + id                            = (known after apply)
      + location                      = "eastus"
      + logical_sector_size           = (known after apply)
      + max_shares                    = (known after apply)
      + name                          = "AzureWebServerMG-0-manged-disk"
      + public_network_access_enabled = true
      + resource_group_name           = "Azuredevops"
      + source_uri                    = (known after apply)
      + storage_account_type          = "Standard_LRS"
      + tags                          = {
          + "env" = "AzureWebServerMG"
        }
      + tier                          = (known after apply)
    }

  # azurerm_managed_disk.main[1] will be created
  + resource "azurerm_managed_disk" "main" {
      + create_option                 = "Empty"
      + disk_iops_read_only           = (known after apply)
      + disk_iops_read_write          = (known after apply)
      + disk_mbps_read_only           = (known after apply)
      + disk_mbps_read_write          = (known after apply)
      + disk_size_gb                  = 1
      + id                            = (known after apply)
      + location                      = "eastus"
      + logical_sector_size           = (known after apply)
      + max_shares                    = (known after apply)
      + name                          = "AzureWebServerMG-1-manged-disk"
      + public_network_access_enabled = true
      + resource_group_name           = "Azuredevops"
      + source_uri                    = (known after apply)
      + storage_account_type          = "Standard_LRS"
      + tags                          = {
          + "env" = "AzureWebServerMG"
        }
      + tier                          = (known after apply)
    }

  # azurerm_network_interface.main[0] will be created
  + resource "azurerm_network_interface" "main" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "eastus"
      + mac_address                   = (known after apply)
      + name                          = "AzureWebServerMG-0-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "Azuredevops"
      + tags                          = {
          + "env" = "AzureWebServerMG"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "AzureWebServerMG-0-ip-configuration"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface.main[1] will be created
  + resource "azurerm_network_interface" "main" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "eastus"
      + mac_address                   = (known after apply)
      + name                          = "AzureWebServerMG-1-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "Azuredevops"
      + tags                          = {
          + "env" = "AzureWebServerMG"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "AzureWebServerMG-1-ip-configuration"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface_backend_address_pool_association.main[0] will be created
  + resource "azurerm_network_interface_backend_address_pool_association" "main" {
      + backend_address_pool_id = (known after apply)
      + id                      = (known after apply)
      + ip_configuration_name   = "AzureWebServerMG-0-ip-configuration"
      + network_interface_id    = (known after apply)
    }

  # azurerm_network_interface_backend_address_pool_association.main[1] will be created
  + resource "azurerm_network_interface_backend_address_pool_association" "main" {
      + backend_address_pool_id = (known after apply)
      + id                      = (known after apply)
      + ip_configuration_name   = "AzureWebServerMG-1-ip-configuration"
      + network_interface_id    = (known after apply)
    }

  # azurerm_network_security_group.main will be created
  + resource "azurerm_network_security_group" "main" {
      + id                  = (known after apply)
      + location            = "eastus"
      + name                = "AzureWebServerMG-nsg"
      + resource_group_name = "Azuredevops"
      + security_rule       = (known after apply)
      + tags                = {
          + "env" = "AzureWebServerMG"
        }
    }

  # azurerm_network_security_rule.mainsr100 will be created
  + resource "azurerm_network_security_rule" "mainsr100" {
      + access                      = "Deny"
      + destination_address_prefix  = "VirtualNetwork"
      + destination_port_range      = "*"
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "DenyVNetInboundFromInternet"
      + network_security_group_name = "AzureWebServerMG-nsg"
      + priority                    = 100
      + protocol                    = "*"
      + resource_group_name         = "Azuredevops"
      + source_address_prefix       = "Internet"
      + source_port_range           = "*"
    }

  # azurerm_public_ip.main will be created
  + resource "azurerm_public_ip" "main" {
      + allocation_method       = "Static"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "eastus"
      + name                    = "AzureWebServerMG-public-ip"
      + resource_group_name     = "Azuredevops"
      + sku                     = "Basic"
      + sku_tier                = "Regional"
      + tags                    = {
          + "env" = "AzureWebServerMG"
        }
    }

  # azurerm_subnet.main will be created
  + resource "azurerm_subnet" "main" {
      + address_prefixes                               = [
          + "10.0.2.0/24",
        ]
      + enforce_private_link_endpoint_network_policies = false
      + enforce_private_link_service_network_policies  = false
      + id                                             = (known after apply)
      + name                                           = "AzureWebServerMG-subnet"
      + resource_group_name                            = "Azuredevops"
      + virtual_network_name                           = "AzureWebServerMG-network"
    }

  # azurerm_subnet_network_security_group_association.main will be created
  + resource "azurerm_subnet_network_security_group_association" "main" {
      + id                        = (known after apply)
      + network_security_group_id = (known after apply)
      + subnet_id                 = (known after apply)
    }

  # azurerm_virtual_machine_data_disk_attachment.main[0] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "main" {
      + caching                   = "ReadWrite"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 1
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.main[1] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "main" {
      + caching                   = "ReadWrite"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 1
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_network.main will be created
  + resource "azurerm_virtual_network" "main" {
      + address_space       = [
          + "10.0.0.0/22",
        ]
      + dns_servers         = (known after apply)
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "eastus"
      + name                = "AzureWebServerMG-network"
      + resource_group_name = "Azuredevops"
      + subnet              = (known after apply)
      + tags                = {
          + "env" = "AzureWebServerMG"
        }
    }

Plan: 21 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_virtual_network.main: Creating...
azurerm_network_security_group.main: Creating...
azurerm_public_ip.main: Creating...
azurerm_availability_set.main: Creating...
azurerm_managed_disk.main[1]: Creating...
azurerm_managed_disk.main[0]: Creating...
azurerm_availability_set.main: Creation complete after 2s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Compute/availabilitySets/AzureWebServerMG-vm-availability-set]
azurerm_public_ip.main: Creation complete after 3s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/publicIPAddresses/AzureWebServerMG-public-ip]
azurerm_lb.main: Creating...
azurerm_managed_disk.main[1]: Creation complete after 4s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Compute/disks/AzureWebServerMG-1-manged-disk]
azurerm_managed_disk.main[0]: Creation complete after 4s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Compute/disks/AzureWebServerMG-0-manged-disk]
azurerm_lb.main: Creation complete after 2s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/AzureWebServerMG-load-balancer]
azurerm_lb_backend_address_pool.main: Creating...
azurerm_lb_probe.main: Creating...
azurerm_network_security_group.main: Creation complete after 6s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/networkSecurityGroups/AzureWebServerMG-nsg]
azurerm_network_security_rule.mainsr100: Creating...
azurerm_virtual_network.main: Creation complete after 6s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/AzureWebServerMG-network]
azurerm_subnet.main: Creating...
azurerm_lb_probe.main: Creation complete after 2s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/AzureWebServerMG-load-balancer/probes/AzureWebServerMG-lb-probe]
azurerm_lb_backend_address_pool.main: Creation complete after 4s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/AzureWebServerMG-load-balancer/backendAddressPools/AzureWebServerMG-backend-address-pool]
azurerm_lb_rule.main: Creating...
azurerm_lb_rule.main: Creation complete after 1s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/AzureWebServerMG-load-balancer/loadBalancingRules/AzureWebServerMG-lb-rule-http]
azurerm_subnet.main: Creation complete after 5s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/AzureWebServerMG-network/subnets/AzureWebServerMG-subnet]
azurerm_subnet_network_security_group_association.main: Creating...
azurerm_network_interface.main[1]: Creating...
azurerm_network_interface.main[0]: Creating...
azurerm_subnet_network_security_group_association.main: Creation complete after 4s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/AzureWebServerMG-network/subnets/AzureWebServerMG-subnet]
azurerm_network_security_rule.mainsr100: Still creating... [10s elapsed]
azurerm_network_interface.main[0]: Creation complete after 5s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/AzureWebServerMG-0-nic]
azurerm_network_security_rule.mainsr100: Creation complete after 11s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/networkSecurityGroups/AzureWebServerMG-nsg/securityRules/DenyVNetInboundFromInternet]
azurerm_network_interface.main[1]: Creation complete after 6s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/AzureWebServerMG-1-nic]
azurerm_network_interface_backend_address_pool_association.main[1]: Creating...
azurerm_network_interface_backend_address_pool_association.main[0]: Creating...
azurerm_linux_virtual_machine.main[1]: Creating...
azurerm_linux_virtual_machine.main[0]: Creating...
azurerm_network_interface_backend_address_pool_association.main[0]: Creation complete after 2s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/AzureWebServerMG-0-nic/ipConfigurations/AzureWebServerMG-0-ip-configuration|/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/AzureWebServerMG-load-balancer/backendAddressPools/AzureWebServerMG-backend-address-pool]
azurerm_network_interface_backend_address_pool_association.main[1]: Creation complete after 2s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/AzureWebServerMG-1-nic/ipConfigurations/AzureWebServerMG-1-ip-configuration|/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/AzureWebServerMG-load-balancer/backendAddressPools/AzureWebServerMG-backend-address-pool]
azurerm_linux_virtual_machine.main[1]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[0]: Creation complete after 48s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/AzureWebServerMG-0-vm]
azurerm_linux_virtual_machine.main[1]: Creation complete after 48s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/AzureWebServerMG-1-vm]
azurerm_virtual_machine_data_disk_attachment.main[1]: Creating...
azurerm_virtual_machine_data_disk_attachment.main[0]: Creating...
azurerm_virtual_machine_data_disk_attachment.main[0]: Still creating... [10s elapsed]
azurerm_virtual_machine_data_disk_attachment.main[1]: Still creating... [10s elapsed]
azurerm_virtual_machine_data_disk_attachment.main[0]: Still creating... [20s elapsed]
azurerm_virtual_machine_data_disk_attachment.main[1]: Still creating... [20s elapsed]
azurerm_virtual_machine_data_disk_attachment.main[1]: Still creating... [30s elapsed]
azurerm_virtual_machine_data_disk_attachment.main[0]: Still creating... [30s elapsed]
azurerm_virtual_machine_data_disk_attachment.main[1]: Creation complete after 32s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/AzureWebServerMG-1-vm/dataDisks/AzureWebServerMG-1-manged-disk]
azurerm_virtual_machine_data_disk_attachment.main[0]: Creation complete after 32s [id=/subscriptions/2576e2a1-0b1e-4545-9622-12ca44208419/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/AzureWebServerMG-0-vm/dataDisks/AzureWebServerMG-0-manged-disk]

Apply complete! Resources: 21 added, 0 changed, 0 destroyed.
