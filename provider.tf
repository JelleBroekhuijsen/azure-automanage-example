terraform {
  cloud {
    organization = "jllio"
    workspaces {
      name = "azure-automanage-example"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.70.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "azurerm" { 
  features {}

  // Uncomment the following lines if you want to use a service principal instead of the current user

  # tenant_id       = var.tenant_id 
  # subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
}

provider "random" {}

data "azurerm_client_config" "current" {}