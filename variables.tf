variable "name" {}

variable "location" {}

variable "address_space" {}

variable "subnets" {
  type    = number
  default = 0
}

variable "subnet_newbits" {
  type    = number
  default = 0
}

variable "ssh_master_key" {}

variable "peering_connections" {
  default = {}
  type = map(object({
    id = string
  }))
}

variable "associate_nat_gateway" {
  type    = bool
  default = true
}

variable "network_security_rules" {
  default = {}
}

variable "storage_account_name" {
  default = null
}

variable "vpn_gateway" {
  type    = bool
  default = false
}

variable "vpn_gateway_subnet_index" {
  type    = number
  default = null
}

variable "vnet2vnet_conns" {
  type = map(object({
    gateway_id = string
    shared_key = string
  }))
  default = {}
}