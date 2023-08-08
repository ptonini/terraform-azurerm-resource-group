variable "name" {
  type    = string
  default = null
}

variable "name_prefix" {
  default = null
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
  type    = map(object({}))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}