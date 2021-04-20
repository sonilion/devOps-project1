# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

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
1. Clone/download repository and copy to working location.

  Repository (for manual download): [Github/sonilion](https://github.com/sonilion/devOps-project1)
```
git clone https://github.com/sonilion/devOps-project1
```
2. Fire up powershell or shell/cp of your choice :-)
3. Navigate to devOps-project1 folder (base directory where this README file is located)
4. Create resource group in Azure to house packer custom images (packer_images). This will contain our webserver image. It should reside in the same location as the rest of the resources.  Example defaulting to westus2 (also currently used by the rest of this project).  
```
az group create -l westus2 -n packer_images
```
5. Build linux web server packer image.  See variables section of server.json if you created your resource group in step 4 elsewhere.
```
packer build server.json
```
6. Review terraform template variables.  From the devOps-project1 folder, navigate to the terraform directory.  

The configuration is broken up into a handful of configuration files for ease of management.  

Text file: vars.tf contains various user managed values.

  * **prefix** : Prepended to some resource names being created via Terraform
  * **location** : The azure region that the terraform template creates resources in
  * **resource_tags** : default tags that will be applied to all indexed resources created by Terraform
  * **numWebMachines** : The number of web servers terraform will create.
  * **admusername & password** : Terraform will prompt for the server admin user/pass at runtime.
  * **createBastion** : Should Terraform build out a bastion host for this infrastructure (default is false)

7. Initialize Terraform.  From the /devOps-project1/terraform directory
```
cd terraform
terraform init
```
8. Create and review Terraform plan.  Terraform show output can be reviewed any time prior to actually applying the plan.
```
terraform plan -out solution.plan
terraform show "solution.plan"
```
9. Once you've confirmed the results, have terraform build the requested infrastructure.
```
terraform apply "solution.plan"
```
10. Once completed, if desired, you can destroy the terraform managed infrastructure that was built.
```
terraform destroy -target azurerm_resource_group.udweb -auto-approve
```

### Expected Output
Terraform should create the requested number of (small) Ubuntu web servers (apache2).  These web servers will be load balanced using the default balancing plan.  Unless modified, the template as delivered will create 3 webservers.

These web servers will not be accessible via the internet/public IP due to lack of security rule.  See the commented nsg rule (allowWWW) to enable.  

This template includes functionality to create a bastion host if desired, but is disabled by default.  
