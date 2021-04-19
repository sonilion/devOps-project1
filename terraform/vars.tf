variable "prefix" {
  description = "The prefix which should be used for all resources in this deployment"
  default = "UWeb"
}

variable "location" {
  description = "The Azure Region in which resources in this deploy will be dumped."
  default = "westus2"
}

variable "admusername" {
  type = string
  description = "The server admin username."

  validation {
    condition = length(var.admusername) >= 4
    error_message = "Admin username must be more than 3 characters."
  }
}

variable "admpassword" {
  type = string
  description = "The server admin password."

  validation {
    condition = length(var.admpassword) >= 8 && can(regex("[0-9]",var.admpassword))
    error_message = "Must be at least 8 chars and contain at least one numeric."
  }
}

variable "resource_tags" {
  description = "Tags to be set for all resources"
  type = map(string)
  default = {
    Project = "UdacityProject1"
    environment = "Production"
  }
}

variable "numWebMachines" {
  description = "Number of Web Servers to deploy"
  default = 3
}

variable "createBastion" {
  type = bool
  description = "Should I create Bastion infrastructure?"
  default = false
}
