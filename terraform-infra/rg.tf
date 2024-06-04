resource "random_id" "random" {
  byte_length = 8
}

resource "azurerm_resource_group" "k8s-rg" {
  name     = "copilot-rg-${resource.random_id.random.hex}"
  location = var.rg-location
}

resource "azurerm_virtual_network" "k8s-vnet" {
  name                = "k8s-vnet"
  resource_group_name = azurerm_resource_group.k8s-rg.name
  location            = azurerm_resource_group.k8s-rg.location
  address_space       = ["172.0.0.0/16"]
}

resource "azurerm_subnet" "node-subnet" {
  name                 = "node-subnet"
  resource_group_name  = azurerm_resource_group.k8s-rg.name
  virtual_network_name = azurerm_virtual_network.k8s-vnet.name
  address_prefixes     = ["172.0.32.0/24"]
}

resource "azurerm_subnet" "pod-subnet" {
  name                 = "pod-subnet"
  resource_group_name  = azurerm_resource_group.k8s-rg.name
  virtual_network_name = azurerm_virtual_network.k8s-vnet.name
  address_prefixes     = ["172.0.48.0/20"]

  delegation {
    name = "aks-delegation"

    service_delegation {
        actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action",
          ]
        name    = "Microsoft.ContainerService/managedClusters"
      }
  }
}