output "this" {
  value = azurerm_resource_group.this
}

output "ssh_key" {
  value = var.master_key == null ? null : azurerm_ssh_public_key.this[0]
}

output "vnet" {
  value = var.vnet_address_space == null ? null : module.vnet[0].this
}

output "subnet_ids" {
  value = [for m in module.subnets : m.this.id]
}

output "subnet_newbits" {
  value = var.subnet_newbits
}

output "name_prefix" {
  value = var.name_prefix
}

output "storage_accounts" {
  value = module.storage_accounts
}