// Fun - Virtual machines and their resources

// get packer image detail

data "azurerm_resource_group" "packer-images" {
  name = "packer_images"
}

data "azurerm_image" "packerLinuxWebImage" {
  name = "packerUbuntuWebServer"
  resource_group_name = data.azurerm_resource_group.packer-images.name
}

resource "azurerm_availability_set" "webvm" {
  name = "${var.prefix}-webAVS"
  location = azurerm_resource_group.udweb.location
  resource_group_name = azurerm_resource_group.udweb.name
  tags = var.resource_tags
}

// define the VM using the packer image and iterate by count

resource "azurerm_virtual_machine" "webvm" {
  count = var.numWebMachines
  name = "${var.prefix}-${format("%02d",count.index + 1)}-linuxWebServer"
  location = azurerm_resource_group.udweb.location
  resource_group_name = azurerm_resource_group.udweb.name
  vm_size = "Standard_B1s"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  availability_set_id = azurerm_availability_set.webvm.id

  network_interface_ids = [
    element(azurerm_network_interface.prod-vnet1.*.id,count.index)
  ]

  storage_image_reference {
    id = data.azurerm_image.packerLinuxWebImage.id
  }

  storage_os_disk {
    name = "webVM-${format("%02d",count.index + 1)}-osDisk"
    caching = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option = "FromImage"
  }

  os_profile {
    computer_name = "${var.prefix}-${format("%02d",count.index + 1)}-ubuntuWebSvr"
    admin_username = var.admusername
    admin_password = var.admpassword
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.resource_tags

}
