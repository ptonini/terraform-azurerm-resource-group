variable "name" {
  type    = string
  default = null
}

variable "name_prefix" {
  default = ""
}

variable "location" {
  type = string
}

variable "master_key" {
  default = null
}

variable "vnet_address_space" {
  default = null
}

variable "nat_gateway" {
  default = false
}

variable "subnets" {
  default = 1
}

variable "subnet_newbits" {
  default = 8
}

variable "peering_connections" {
  default = {}
  type = map(object({
    id = string
  }))
}

variable "vnet_gateway" {
  default = false
}

variable "vnet_gateway_subnet_index" {
  default = 255
}

variable "site2site_conns" {
  type = map(object({
    gateway_address = string
    address_space   = set(string)
    shared_key      = string
    ipsec_policy = optional(object({
      dh_group         = optional(string)
      ike_encryption   = optional(string)
      ike_integrity    = optional(string)
      ipsec_encryption = optional(string)
      ipsec_integrity  = optional(string)
      pfs_group        = optional(string)
    }), {})
  }))
  default = {}
}

variable "vnet2vnet_conns" {
  type = map(object({
    gateway_id = string
    shared_key = string
  }))
  default = {}
}

variable "vnet_gateway_vpn_client" {
  default = null
}

variable "vnet_gateway_custom_routes" {
  default = null
}

variable "storage_accounts" {
  type = map(object({
    account_tier                      = optional(string)
    account_replication_type          = optional(string)
    queue_encryption_key_type         = optional(string)
    table_encryption_key_type         = optional(string)
    infrastructure_encryption_enabled = optional(bool)
    randomize_name                    = optional(bool)
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}