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

Packer will exit without any output. It is not ready to build the image.

Build the image using the command `packer build server.json`

Note: you can verify the image using the command `az image list`

**2. Create resources including load balancer using Terraform**
1. Run `terraform init` to initialise Terraform
3. Run `terraform plan -out solution.plan` to view what will be created
4. Run `terraform apply` to build the web server and load balancer


### How to customise the vars.tf file

Vars.tf includes 5 variables, all with default values. In order to customise the default values for any of these fields, change the relavant 'default' value.   

### Output
**Your words here**
