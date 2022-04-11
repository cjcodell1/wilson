#foreach https://buildvirtual.net/terraform-for-each-loop-examples/
## <https://www.terraform.io/docs/providers/azurerm/r/resource_group.html>
resource "azurerm_resource_group" "Env1_rg" {
  name     = "Env1_rg"
  location = "eastus"
}

## <https://www.terraform.io/docs/providers/azurerm/r/availability_set.html>
resource "azurerm_availability_set" "Env1_DemoASet" {
  name                = "Env1_DemoASet"
  location            = azurerm_resource_group.Env1_rg.location
  resource_group_name = azurerm_resource_group.Env1_rg.name
}

## <https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html>
resource "azurerm_virtual_network" "Env1_vnet" {
  name                = "Env1_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Env1_rg.location
  resource_group_name = azurerm_resource_group.Env1_rg.name
}

## <https://www.terraform.io/docs/providers/azurerm/r/subnet.html> 
resource "azurerm_subnet" "subnet" {
  name                 = "Env1_internal"
  resource_group_name  = azurerm_resource_group.Env1_rg.name
  virtual_network_name = azurerm_virtual_network.Env1_vnet.name
  address_prefixes       = ["10.0.2.0/24"]
  }

//will need to foreach this 

resource "azurerm_public_ip" "Env1_PubIP" {
  for_each            = toset(var.vm_names)
  name                = "${each.value}-PubIP"
  resource_group_name = azurerm_resource_group.Env1_rg.name
  location            = azurerm_resource_group.Env1_rg.location
  allocation_method   = "Dynamic"
}
resource "azurerm_public_ip" "Env1_PubIP2" {
  name                = "Env1_PubIP2"
  resource_group_name = azurerm_resource_group.Env1_rg.name
  location            = azurerm_resource_group.Env1_rg.location
  allocation_method   = "Dynamic"
}

## <https://www.terraform.io/docs/providers/azurerm/r/network_interface.html>
//this
resource "azurerm_network_interface" "Env1_NIC" {
  for_each            = toset(var.vm_names)
  name                = "${each.value}-nic"
  //name                = "Env1_NIC"
  location            = azurerm_resource_group.Env1_rg.location
  resource_group_name = azurerm_resource_group.Env1_rg.name
  
  ip_configuration {
    name                          = "Env1_rg_internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.Env1_PubIP[each.key].id
  }
}

resource "azurerm_network_interface" "Env1_NIC2" {
  name                = "Env1_NIC2"
  location            = azurerm_resource_group.Env1_rg.location
  resource_group_name = azurerm_resource_group.Env1_rg.name

  ip_configuration {
    name                          = "Env2_rg_internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.Env1_PubIP2.id
  }
}

#Create and display a SSH Key: https://docs.microsoft.com/en-us/azure/developer/terraform/create-linux-virtual-machine-with-infrastructure#:~:text=Key%20points%3A%20The%20machine%20will%20be%20created%20with,it%20to%20log%20in%20to%20the%20virtual%20machine.
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

/*output "tls_private_key" { 
    value = tls_private_key.example_ssh.private_key_pem 
    sensitive = true
}*/
data "azurerm_image" "MDisk" {
  name                = "ubuntu-baseline"
  resource_group_name = "MDisk_rg"
}
data "azurerm_image" "ControllerDisk" {
  name                = "controller"
  resource_group_name = "MDisk_rg"
}
#<https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html>
resource "azurerm_linux_virtual_machine" "Env1_VM" {
  for_each            = toset(var.vm_names)
  name                = each.value
  admin_username = "rootazure"
  admin_password      = "P@ssw0rd"
  disable_password_authentication = false
  resource_group_name = azurerm_resource_group.Env1_rg.name
  location            = azurerm_resource_group.Env1_rg.location
  network_interface_ids = [
    azurerm_network_interface.Env1_NIC[each.key].id,
    ]
  availability_set_id = azurerm_availability_set.Env1_DemoASet.id
  size               = "Standard_DS1_v2" #guillermo
  computer_name = "TestForEachVMs"   
//this
  os_disk {
    //name              = "VM1_disk"
    caching           = "ReadWrite"
    //create_option     = "FromImage"
    storage_account_type = "Standard_LRS"
}
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine
  /*source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS" 
    version   = "latest"
  }*/
  
  source_image_id = data.azurerm_image.MDisk.id

#https://stackoverflow.com/questions/63413564/terraform-azure-vm-ssh-key

   admin_ssh_key {
        username       = "rootazure"
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

}

resource "azurerm_linux_virtual_machine" "Env1_Controller" {
  name                = "controller_vm"
  admin_username = "rootazure"
  admin_password      = "P@ssw0rd"
  disable_password_authentication = false
  resource_group_name = azurerm_resource_group.Env1_rg.name
  location            = azurerm_resource_group.Env1_rg.location
  network_interface_ids = [
    azurerm_network_interface.Env1_NIC2.id,
    ]
  availability_set_id = azurerm_availability_set.Env1_DemoASet.id
  size               = "Standard_DS1_v2" #guillermo
  computer_name = "TestForEachVMs1"   
//this
  os_disk {
    //name              = "VM1_disk"
    caching           = "ReadWrite"
    //create_option     = "FromImage"
    storage_account_type = "Standard_LRS"
}
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine
  /*source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS" 
    version   = "latest"
  }*/
  
  source_image_id = data.azurerm_image.ControllerDisk.id

#https://stackoverflow.com/questions/63413564/terraform-azure-vm-ssh-key

   admin_ssh_key {
        username       = "rootazure"
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

}


resource "azurerm_network_security_group" "Env1_NSG" {
  name                = "Env1_http_and_ssh"
  location            = azurerm_resource_group.Env1_rg.location
  resource_group_name = azurerm_resource_group.Env1_rg.name

  security_rule {
    name                       = "AllowHTTPInBound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSHInBound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "SQLConnection"
    priority                   = 121
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "AzureCloud"
    destination_address_prefix = "*"
  }
 
}




# Connect security group to network interface. 
resource "azurerm_network_interface_security_group_association" "NSG-Association" {
  for_each = toset(var.vm_names)
  network_interface_id =    azurerm_network_interface.Env1_NIC[each.value].id 
  network_security_group_id = azurerm_network_security_group.Env1_NSG.id
}


resource "azurerm_network_interface_security_group_association" "NSG-Association1" {
  network_interface_id =    azurerm_network_interface.Env1_NIC2.id 
  network_security_group_id = azurerm_network_security_group.Env1_NSG.id
}

#Spin up log analytics and Sentinel - https://msandbu.org/automating-azure-sentinel-deployment-using-terraform-and-powershell/?msclkid=e07d3966afd311eca5012ed5ab725cba
#log analytics
resource "azurerm_log_analytics_workspace" "Env1LogAnalytics" {
  name                = "Env1LogAnalytics"
  location            =  azurerm_resource_group.Env1_rg.location
  resource_group_name =  azurerm_resource_group.Env1_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 90
}

resource "azurerm_log_analytics_solution" "Env1Sentinel" {
  solution_name         = "SecurityInsights"
  location              = azurerm_resource_group.Env1_rg.location
  resource_group_name   = azurerm_resource_group.Env1_rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.Env1LogAnalytics.id
  workspace_name        = azurerm_log_analytics_workspace.Env1LogAnalytics.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

# Windows machines
resource "azurerm_network_interface" "Env1_NIC3" {
  for_each            = toset(var.vm_names1)
  name                = "${each.value}-nic3"
  //name                = "Env1_NIC"
  location            = azurerm_resource_group.Env1_rg.location
  resource_group_name = azurerm_resource_group.Env1_rg.name

  ip_configuration {
    name                          = "Env1_rg_internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    //public_ip_address_id = azurerm_public_ip.Env1_PubIP.id
  }
}

resource "azurerm_windows_virtual_machine" "Env1_Win" {
  for_each = toset(var.vm_names1)
  name = each.value
  resource_group_name = azurerm_resource_group.Env1_rg.name
  location            = azurerm_resource_group.Env1_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd"
  disable_password_authentication = false
  availability_set_id = azurerm_availability_set.Env1_DemoASet.id
  computer_name       = "WindowsVM"
  network_interface_ids = [
    azurerm_network_interface.Env1_NIC3[each.key].id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface_security_group_association" "NSG-AssociationWindows" {
  for_each = toset(var.vm_names1)
  network_interface_id =    azurerm_network_interface.Env1_NIC3[each.key].id
  network_security_group_id = azurerm_network_security_group.Env1_NSG.id
}
