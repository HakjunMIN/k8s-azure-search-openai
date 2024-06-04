resource "azurerm_container_registry" "acr" {
  name                = "${var.registry_name}${resource.random_id.random.hex}"
  resource_group_name = azurerm_resource_group.k8s-rg.name
  location            = azurerm_resource_group.k8s-rg.location
  sku                 = "Premium"
  admin_enabled       = true
}