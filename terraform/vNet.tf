// Virtual network terraform objects

// production vnet for Udacity project (1)
resource "azurerm_virtual_network" "prod-vnet1" {
  name = "${var.prefix}-prod-vnet1"
  address_space = ["10.0.0.0/22"]
  location = azurerm_resource_group.udweb.location
  resource_group_name = azurerm_resource_group.udweb.name

  subnet {
    name = "${var.prefix}-subnet1"
    address_prefix = "10.0.1.0/24"
  }

  tags = var.resource_tags
}

// only need 1 public ip to the LB
resource "azurerm_public_ip" "prod-vnet1" {
  name = "${var.prefix}-publicIP"
  location = azurerm_resource_group.udweb.location
  resource_group_name = azurerm_resource_group.udweb.name
  allocation_method = "Static"
  tags = var.resource_tags
}

// NICs for the internal web VMs
resource "azurerm_network_interface" "prod-vnet1" {
  count = var.numWebMachines
  name = "${var.prefix}-${format("%02d",count.index + 1)}-NIC"
  location = azurerm_resource_group.udweb.location
  resource_group_name = azurerm_resource_group.udweb.name

  ip_configuration {
    name = "${var.prefix}-${format("%02d",count.index + 1)}-internal"
    subnet_id = azurerm_virtual_network.prod-vnet1.subnet.*.id[0]
    private_ip_address_allocation = "dynamic"
  }
  tags = var.resource_tags
}
