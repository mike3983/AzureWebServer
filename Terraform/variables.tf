variable "resource_group" {
    description = "Resource group for all project resources"
    default = "Azuredevops"
}

variable "custom_image" {
    description = "image created using Packer"
    default = "projectImage"
}

variable "location" {
    description = "Azure region where resources will be located"
    default = "East US"
}

variable "username" {
  description = "username for VMs"
}


variable "password" {
  description = "password for VMs"
}

variable "prefix" {
  description = "naming convention for all created cresources"
  default = "AzureWebServerMG"
}

variable "vm_count" {
  description = "number of virtual machines to be deployed"
  default = "2" 
}
