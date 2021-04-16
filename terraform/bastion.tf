// bastion Resources

// bastion publicIP

resource "azurerm_public_ip" "bastionHost" {
  name = "${var.prefix}-bastion-publicIP"
  location = azurerm_resource_group.udweb.location
  resource_group_name = azurerm_resource_group.udweb.name
  allocation_method = "Static"
  sku = "Standard"
  tags = var.resource_tags
}

resource "azurerm_bastion_host" "bastionHost" {
  name = "${var.prefix}-bastionHost"
  location = azurerm_resource_group.udweb.location
  resource_group_name = azurerm_resource_group.udweb.name

  ip_configuration {
    name = "bastion"
    subnet_id = azurerm_virtual_network.prod-vnet1.subnet.*.id[1]
    public_ip_address_id = azurerm_public_ip.bastionHost.id
  }
  tags = var.resource_tags
}
