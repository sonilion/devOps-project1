variable "prefix" {
  description = "The prefix which should be used for all resources in this deployment"
  default = "UWeb"
}

variable "location" {
  description = "The Azure Region in which resources in this deploy will be dumped."
  default = "westus2"
}

variable "admusername" {
  description = "The server admin username."
}

variable "admpassword" {
  description = "The server admin password."
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
