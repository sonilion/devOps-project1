// Terraform resource groups
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "udweb" {
  name = "${var.prefix}-resources"
  location = var.location
  tags = var.resource_tags
}

/*
resource "azurerm_resource_group" "packer-images" {
  name = "packer_images"
  location = var.location
  tags = var.resource_tags

  lifecycle {
    prevent_destroy = true
  }
}
*/
