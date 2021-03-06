// bastion Resources

// bastion publicIP

resource "azurerm_subnet" "bastionHost"{
  count = var.createBastion ? 1 : 0 // if false then don't create
  name = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.prod-vnet1.name
  address_prefixes = ["10.0.2.224/27"]
  resource_group_name = azurerm_resource_group.udweb.name
}

resource "azurerm_public_ip" "bastionHost" {
  count = var.createBastion ? 1 : 0 // if false then don't create
  name = "${var.prefix}-bastion-publicIP"
  location = azurerm_resource_group.udweb.location
  resource_group_name = azurerm_resource_group.udweb.name
  allocation_method = "Static"
  sku = "Standard"
  tags = var.resource_tags
}

resource "azurerm_bastion_host" "bastionHost" {
  count = var.createBastion ? 1 : 0 // if false then don't create
  name = "${var.prefix}-bastionHost"
  location = azurerm_resource_group.udweb.location
  resource_group_name = azurerm_resource_group.udweb.name

  ip_configuration {
    name = "bastion"
    subnet_id = azurerm_subnet.bastionHost.*.id[0]
    public_ip_address_id = azurerm_public_ip.bastionHost.*.id[0]
  }
  tags = var.resource_tags
}
