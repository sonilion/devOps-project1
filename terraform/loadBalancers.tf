// Load balancer and related objects

resource "azurerm_lb" "weblb" {
  name = "${var.prefix}-loadBalancer"
  location = azurerm_resource_group.udweb.location
  resource_group_name = azurerm_resource_group.udweb.name

  frontend_ip_configuration {
    name = "${var.prefix}-lb-pubIP"
    public_ip_address_id = azurerm_public_ip.prod-vnet1.id
  }

  tags = var.resource_tags
}

resource "azurerm_lb_backend_address_pool" "weblb" {
  name = "${var.prefix}-lb-backendpool"
  loadbalancer_id = azurerm_lb.weblb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "weblb" {
  count = var.numWebMachines
  network_interface_id = azurerm_network_interface.prod-vnet1.*.id[count.index]
  ip_configuration_name = "${var.prefix}-${format("%02d",count.index + 1)}-internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.weblb.id
}

resource "azurerm_lb_rule" "weblb" {
  resource_group_name = azurerm_resource_group.udweb.name
  loadbalancer_id = azurerm_lb.weblb.id
  name = "lbRule-Web"
  protocol = "tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = "${var.prefix}-lb-pubIP"
  backend_address_pool_id = azurerm_lb_backend_address_pool.weblb.id
  probe_id = azurerm_lb_probe.weblb.id
}

resource "azurerm_lb_probe" "weblb" {
  resource_group_name = azurerm_resource_group.udweb.name
  name = "httpd-probe"
  request_path = "/"
  loadbalancer_id = azurerm_lb.weblb.id
  interval_in_seconds = 60
  number_of_probes = 5
  protocol = "Http"
  port = 80
}
