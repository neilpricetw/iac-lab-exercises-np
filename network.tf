resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = format("%s-vpc", var.prefix)
  }
}

resource "aws_subnet" "public_subnets" {
  count = var.number_of_public_subnets 

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet("192.168.1.0/25",3, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("%s-public-subnet-%s", var.prefix, count.index)
  }
}

resource "aws_subnet" "private_subnets" {
  count = var.number_of_private_subnets 
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet("192.168.1.0/25",3, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("%s-private-subnet-%s", var.prefix, count.index)
  }
}

resource "aws_subnet" "secure_subnets" {
  count = var.number_of_secure_subnets 

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet("192.168.1.0/25",3, count.index + 4)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = {
    Name = format("%s-secure-subnet-%s", var.prefix, count.index)
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-ig", var.prefix)
  }
}

resource "aws_eip" "ip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.public_subnets[1].id

  tags = {
    Name = format("%s-nat-gw", var.prefix)
  }

  depends_on = [aws_internet_gateway.ig]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = format("%s-public-route-table", var.prefix)
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = format("%s-private-route-table", var.prefix)
  }
}

resource "aws_route_table_association" "public_subnets" {
  for_each = { for name, subnet in aws_subnet.public_subnets : name => subnet }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "private_subnets" {
  for_each = { for name, subnet in aws_subnet.private_subnets : name => subnet }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}