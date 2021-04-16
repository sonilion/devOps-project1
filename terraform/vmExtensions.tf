// post build commands

resource "azurerm_virtual_machine_extension" "webvmext" {
  count = var.numWebMachines
  name = "webVM-apache2"
  virtual_machine_id = azurerm_virtual_machine.webvm.*.id[count.index]
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version ="2.0"
  tags = var.resource_tags
  settings = <<SETTINGS
    {
      "commandToExecute" : "apt-get -y update",
      "commandToExecute" : "apt-get install -y apache2"
    }
    SETTINGS
}
