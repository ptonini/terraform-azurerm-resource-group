locals {
  name        = coalesce(var.name, "${var.name_prefix}-rg")
  name_prefix = coalesce(var.name, var.name_prefix)
}

resource "azurerm_resource_group" "this" {
  name     = coalesce(var.name, "${var.name_prefix}-rg")
  location = var.location
  tags     = var.tags
  lifecycle {
    ignore_changes = [
      tags.business_unit,
      tags.environment,
      tags.product,
      tags.subscription_type
    ]
  }
}

resource "azurerm_ssh_public_key" "this" {
  count               = var.master_key == null ? 0 : 1
  name                = coalesce(var.name, "${var.name_prefix}-master-key")
  resource_group_name = upper(azurerm_resource_group.this.name)
  location            = azurerm_resource_group.this.location
  public_key          = var.master_key
  lifecycle {
    ignore_changes = [
      tags.business_unit,
      tags.environment,
      tags.product,
      tags.subscription_type
    ]
  }
}

module "vnet" {
  source              = "ptonini/vnet/azurerm"
  version             = "~> 2.0.0"
  count               = var.vnet_address_space == null ? 0 : 1
  name                = coalesce(var.name, "${var.name_prefix}-vnet")
  rg                  = azurerm_resource_group.this
  address_space       = var.vnet_address_space
  peering_connections = var.peering_connections
}

module "nat_gateway" {
  source  = "ptonini/nat-gateway/azurerm"
  version = "~> 1.0.1"
  count   = var.nat_gateway ? 1 : 0
  name    = coalesce(var.name, "${var.name_prefix}-nat-gateway")
  rg      = azurerm_resource_group.this
}

module "subnets" {
  source           = "ptonini/subnet/azurerm"
  version          = "~> 1.0.0"
  count            = var.vnet_address_space == null ? 0 : var.subnets
  name             = "subnet${format("%04.0f", count.index + 1)}"
  rg               = azurerm_resource_group.this
  vnet             = module.vnet[0].this
  address_prefixes = [cidrsubnet(var.vnet_address_space[0], var.subnet_newbits, count.index)]
  nat_gateway      = var.nat_gateway ? module.nat_gateway[0].this : null
}

module "vnet_gateway" {
  source           = "ptonini/vnet-gateway/azurerm"
  version          = "~> 2.1.0"
  count            = var.vnet_gateway ? 1 : 0
  name             = coalesce(var.name, "${var.name_prefix}-vnet-gateway")
  rg               = azurerm_resource_group.this
  vnet             = module.vnet[0].this
  address_prefixes = [cidrsubnet(var.vnet_address_space[0], var.subnet_newbits, var.vnet_gateway_subnet_index)]
  custom_routes    = var.vnet_gateway_custom_routes
  vpn_client       = var.vnet_gateway_vpn_client
  vnet2vnet_conns  = var.vnet2vnet_conns
  site2site_conns  = var.site2site_conns
}

module "storage_accounts" {
  source                            = "ptonini/storage-account/azurerm"
  version                           = "~> 2.0.0"
  for_each                          = var.storage_accounts
  name                              = each.key
  rg                                = azurerm_resource_group.this
  randomize_name                    = each.value.randomize_name
  account_tier                      = each.value.account_tier
  account_replication_type          = each.value.account_replication_type
  queue_encryption_key_type         = each.value.queue_encryption_key_type
  table_encryption_key_type         = each.value.table_encryption_key_type
  infrastructure_encryption_enabled = each.value.infrastructure_encryption_enabled
}