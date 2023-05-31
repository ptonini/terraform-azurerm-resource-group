resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
}

resource "azurerm_ssh_public_key" "this" {
  name                = var.name
  location            = azurerm_resource_group.this.location
  resource_group_name = upper(azurerm_resource_group.this.name)
  public_key          = var.ssh_master_key
}

module "vnet" {
  source              = "ptonini/vnet/azurerm"
  version             = "~> 1.0.2"
  name                = var.name
  rg                  = azurerm_resource_group.this
  address_space       = var.address_space
  peering_connections = var.peering_connections
}

module "nat_gateway" {
  source  = "ptonini/nat-gateway/azurerm"
  version = "~> 1.0.1"
  name    = var.name
  rg      = azurerm_resource_group.this
}

module "subnets" {
  source           = "ptonini/subnet/azurerm"
  version          = "~> 1.0.0"
  count            = var.subnets
  name             = "subnet${format("%04.0f", count.index + 1)}"
  rg               = azurerm_resource_group.this
  vnet             = module.vnet.this
  address_prefixes = [cidrsubnet(var.address_space, var.subnet_newbits, count.index)]
  nat_gateway      = var.associate_nat_gateway ? module.nat_gateway.this : null
}

module "vpn_gateway" {
  source           = "ptonini/vpn-gateway/azurerm"
  version          = "~> 1.0.0"
  count            = var.vpn_gateway ? 1 : 0
  name             = var.name
  rg               = azurerm_resource_group.this
  vnet             = module.vnet.this
  address_prefixes = [cidrsubnet(var.address_space, var.subnet_newbits, var.vpn_gateway_subnet_index)]
  vnet2vnet_conns  = var.vnet2vnet_conns
}

module "storage_account" {
  source             = "ptonini/storage-account/azurerm"
  version            = "~> 1.0.2"
  name               = coalesce(var.storage_account_name, var.name)
  random_name_suffix = var.storage_account_name == null ? true : false
  rg                 = azurerm_resource_group.this
}