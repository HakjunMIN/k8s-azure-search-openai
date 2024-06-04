resource "azurerm_kubernetes_cluster" "k8s" {
    name                = "${var.cluster_name}-${resource.random_id.random.hex}"
    resource_group_name = azurerm_resource_group.k8s-rg.name
    location            = azurerm_resource_group.k8s-rg.location

    dns_prefix = var.dns_prefix
    kubernetes_version = "1.27.7"

    default_node_pool {
        name = "default"
        node_count = 2
        vm_size = "Standard_D2_v2"
        vnet_subnet_id = azurerm_subnet.node-subnet.id
        pod_subnet_id = azurerm_subnet.pod-subnet.id
    }

    identity {
        type = "SystemAssigned"
    }

    http_application_routing_enabled = alltrue([true])

    network_profile {
        load_balancer_sku = "standard"
        network_plugin = "azure"
    }
}

resource "azurerm_role_assignment" "aks-rg-assignment" {
    scope = azurerm_container_registry.acr.id
    role_definition_name = "AcrPull"
    principal_id = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
    skip_service_principal_aad_check = true
}