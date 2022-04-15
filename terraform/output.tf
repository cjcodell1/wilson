output "resource_group_name" {
    value = azurerm_resource_group.Env1_rg.name
}

output "tls_private_key" { 
    value = tls_private_key.example_ssh.private_key_pem 
    sensitive = true
}

output "attacker_pub_ip" {
  value = azurerm_public_ip.Env1_PubIP4.name
}
