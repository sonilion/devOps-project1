// Network Security group related objects

resource "azurerm_network_security_group" "nsg1" {
  name = "${var.prefix}-1-nsg"
  location = azurerm_resource_group.udweb.location
  resource_group_name = azurerm_resource_group.udweb.name

  security_rule {
    name = "allowVnet2Vnet"
    priority = 110
    direction = "inbound"
    access = "allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name = "denyInet"
    priority = 111
    direction = "Outbound"
    access = "Deny"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "Internet"
  }

/*
 // Enable to allow access to the public IP via the internet.
  security_rule {
    name = "allowWWW"
    priority = 1002
    direction = "inbound"
    access = "Allow"
    protocol = "tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "Internet"
    destination_address_prefix = "VirtualNetwork"
  }
*/

  security_rule {
    name = "denyInboundInet"
    priority = 1010
    direction = "inbound"
    access = "deny"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "Internet"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = var.resource_tags
}
