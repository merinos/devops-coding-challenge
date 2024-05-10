variable "name" {
  description = "Name to be used on all the VPC resources as identifier"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "map with az name as key"
  type = map(object({
    private_subnet     = optional(string, null)
    private_nat_subnet = string
    public_subnet      = string
  }))
}

variable "dhcp_options" {
  description = "dhcp options to set"
  type = object({
    ntp_servers = list(string)
    dns_servers = list(string)
    domain_name = string
  })
  default = null
}
