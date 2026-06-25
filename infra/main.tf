terraform {
  cloud {
    organization = "nohin-portfolio"
    workspaces {
      name = "portfolio-prod"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# Reference existing Resource Group — not creating a new one
data "azurerm_resource_group" "portfolio" {
  name = var.resource_group_name
}

# New Azure Static Web App in the existing Resource Group
resource "azurerm_static_site" "portfolio" {
  name                = var.app_name
  resource_group_name = data.azurerm_resource_group.portfolio.name

  # Static Web Apps is only available in select regions
  location = "eastasia"

  sku_tier = "Free"
  sku_size = "Free"

  tags = {
    project     = "portfolio"
    environment = "production"
    managed_by  = "terraform"
  }
}
