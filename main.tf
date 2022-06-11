terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  backend "azurerm" {
    resource_group_name = "rg-terraform-state"
    storage_account_name = "dhterraform"
    container_name = "tfstate"
    key = "prod.terraform.tfstate"
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

module "bing_forwarder" {
    source = "./modules/bing_forwarder"
    resource_group_name = "FrontDoorExampleResourceGroup"
    location = "uksouth"
}