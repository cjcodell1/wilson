variable "prefix" {
  type = string
  default = "Env1"
  description = "Environment 1"
} 

variable "resource_group_name_prefix" {
  default       = "rg"
  description   = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default = "eastus"
  description   = "Location of the resource group."
}

/*variable "tls_private_key"  {
  default = "example_ssh"
  algorithm = "RSA"
  rsa_bits = 4096*/

  variable "vm_names" {
  description = "VM Names"
  default     = ["linux_1","linux_2","linux_3"]
  type        = set(string)
} 

  variable "vm_names1" {
  description = "VM Names"
  default     = ["windows_1"]
  type        = set(string)
}
