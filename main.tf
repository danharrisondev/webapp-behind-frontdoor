terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.10.0"
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

resource "azurerm_resource_group" "dhexpressapp" {
  name     = "dhexpressapp"
  location = "uksouth"
}

resource "azurerm_service_plan" "dhexpressapp" {
  name = "dhexpressapp"
  resource_group_name = azurerm_resource_group.dhexpressapp.name
  location = azurerm_resource_group.dhexpressapp.location
  sku_name = "B1"
  os_type = "Linux"
}

resource "azurerm_linux_web_app" "dhexpressapp" {
  name = "dhexpressapp"
  resource_group_name = azurerm_resource_group.dhexpressapp.name
  location = azurerm_resource_group.dhexpressapp.location
  service_plan_id = azurerm_service_plan.dhexpressapp.id
  zip_deploy_file = "./Archive.zip"

  app_settings = {
    "PORT" = "80"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
  }

  site_config {
    application_stack {
      node_version = "16-lts"
    }
  }
}