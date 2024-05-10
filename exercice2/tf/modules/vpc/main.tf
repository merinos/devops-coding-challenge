resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = format("%s", var.name)
  }
}

resource "aws_subnet" "private_subnet" {
  for_each          = { for k, v in var.azs : k => v if v.private_subnet != null }
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.private_subnet
  availability_zone = each.key
  tags = {
    "Name"    = format("%s-private-%s", var.name, each.key)
    "Network" = "private_subnet"
  }
}

resource "aws_subnet" "private_nat_subnet" {
  for_each          = { for k, v in var.azs : k => v if v.private_nat_subnet != null }
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.private_nat_subnet
  availability_zone = each.key
  tags = {
    "Name"    = format("%s-private_nat-%s", var.name, each.key)
    "Network" = "private_nat_subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each          = { for k, v in var.azs : k => v if v.public_subnet != null }
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.public_subnet
  availability_zone = each.key
  tags = {
    "Name"    = format("%s-public-%s", var.name, each.key)
    "Network" = "public_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = format("%s-igw", var.name)
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = format("%s-public", var.name)
  }
}

resource "aws_route" "route_public" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "rt_private_nat" {
  for_each = { for k, v in var.azs : k => v if v.private_nat_subnet != null }
  vpc_id   = aws_vpc.vpc.id
  tags = {
    "Name" = format("%s-private-nat-%s", var.name, each.key)
  }
}

resource "aws_eip" "natgw_eip" {
  for_each = { for k, v in var.azs : k => v if v.private_nat_subnet != null }
  vpc      = true
  tags = {
    "Name" = format(
      "eip for %s-natgw-%s",
      var.name,
      each.key,
    )
  }
}

resource "aws_nat_gateway" "natgw" {
  for_each      = { for k, v in var.azs : k => v if v.private_nat_subnet != null }
  allocation_id = aws_eip.natgw_eip[each.key].id
  subnet_id     = aws_subnet.public_subnet[each.key].id
  tags = {
    "Name" = format("%s-natgw-%s", var.name, each.key)
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "route_natgw" {
  for_each               = aws_route_table.rt_private_nat
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw[each.key].id
}

resource "aws_route_table_association" "private_nat" {
  for_each       = aws_subnet.private_nat_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt_private_nat[each.value.availability_zone].id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_vpc_dhcp_options" "vpc_dhcp_options" {
  domain_name_servers = ["AmazonProvidedDNS"]
  ntp_servers         = ["169.254.169.123"]
  tags = {
    "Name" = format("%s-vpc-dhcp-options", var.name)
  }
}

resource "aws_vpc_dhcp_options_association" "vpc_dhcp_options_association" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.vpc_dhcp_options.id
}
