terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  backend "azurerm" {
    resource_group_name  = "nick"
    storage_account_name = "az500storageaccount1"
    container_name       = "tfstate"
    key                  = "devOps.terraform.tfstate"
  }

  required_version = ">= 1.0.11"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "westus2"

	tags = {
		"env" = "terraform getting started"
		"team" = "devOps"
	}
}

resource "azurerm_virtual_network" "vnet" {
	name = "myTFVnt"
	address_space = ["10.0.0.0/16"]
	location = "westus2"
	resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_storage_account" "storage" {
  name = "nickasdasdadsfasdstorage"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "GRS"

  tags = {
		"env" = "terraform getting started"
		"team" = "devOps"
	}
}

resource "azurerm_storage_container" "container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}