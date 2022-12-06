output "this" {
  value = azurerm_resource_group.this
}

output "ssh_key" {
  value = azurerm_ssh_public_key.this
}

output "vnet" {
  value = module.vnet.this
}

output "nat_gateway" {
  value = module.nat_gateway.this
}

output "nat_gateway_public_ip" {
  value = module.nat_gateway.public_ip
}

output "subnet_ids" {
  value = [for m in module.subnets : m.this.id]
}

output "vpn_gateway_id" {
  value = var.vpn_gateway ? module.vpn_gateway[0].this["id"] : null
}

output "vpn_gateway_public_ip" {
  value = var.vpn_gateway ? module.vpn_gateway[0].public_ip : null
}

output "subnet_newbits" {
  value = var.subnet_newbits
}

output "storage_account" {
  value = module.storage_account.this
}