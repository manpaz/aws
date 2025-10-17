# Network Module - VPC, Subnets, Gateways, Route Tables

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-vpc"
    "bashlinux:network-visibility" = "public"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-internet-gateway"
    "bashlinux:network-visibility" = "public"
  })
}

# Egress Only Internet Gateway for IPv6
resource "aws_egress_only_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-egress-only-igw"
  })
}

# IPv6 CIDR Block
resource "aws_vpc_ipv6_cidr_block_association" "main" {
  vpc_id            = aws_vpc.main.id
  ipv6_cidr_block   = "2001:db8::/56"
  assign_ipv6_cidr_block = true
}

# Public Subnets
resource "aws_subnet" "public_1a" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.public_subnet_1a_cidr
  availability_zone               = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch        = true
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc_ipv6_cidr_block_association.main.ipv6_cidr_block, 8, 0)

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-public-subnet-1a"
    "bashlinux:application-tier" = "ec2"
    "bashlinux:network-visibility" = "public"
  })
}

resource "aws_subnet" "public_1b" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.public_subnet_1b_cidr
  availability_zone               = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch        = true
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc_ipv6_cidr_block_association.main.ipv6_cidr_block, 8, 1)

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-public-subnet-1b"
    "bashlinux:application-tier" = "ec2"
    "bashlinux:network-visibility" = "public"
  })
}

resource "aws_subnet" "public_2a" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.public_subnet_2a_cidr
  availability_zone               = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch        = true
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc_ipv6_cidr_block_association.main.ipv6_cidr_block, 8, 2)

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-public-subnet-2a"
    "bashlinux:application-tier" = "alb"
    "bashlinux:network-visibility" = "public"
  })
}

resource "aws_subnet" "public_2b" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.public_subnet_2b_cidr
  availability_zone               = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch        = true
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc_ipv6_cidr_block_association.main.ipv6_cidr_block, 8, 3)

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-public-subnet-2b"
    "bashlinux:application-tier" = "alb"
    "bashlinux:network-visibility" = "public"
  })
}

# Private Subnets
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-private-subnet-1a"
    "bashlinux:application-tier" = "ec2"
    "bashlinux:network-visibility" = "private"
  })
}

resource "aws_subnet" "private_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-private-subnet-1b"
    "bashlinux:application-tier" = "ec2"
    "bashlinux:network-visibility" = "private"
  })
}

resource "aws_subnet" "private_2a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-private-subnet-2a"
    "bashlinux:application-tier" = "documentdb"
    "bashlinux:network-visibility" = "private"
  })
}

resource "aws_subnet" "private_2b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-private-subnet-2b"
    "bashlinux:application-tier" = "documentdb"
    "bashlinux:network-visibility" = "private"
  })
}

resource "aws_subnet" "private_3a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_3a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-private-subnet-3a"
    "bashlinux:application-tier" = "elasticache"
    "bashlinux:network-visibility" = "private"
  })
}

resource "aws_subnet" "private_3b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_3b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-private-subnet-3b"
    "bashlinux:application-tier" = "elasticache"
    "bashlinux:network-visibility" = "private"
  })
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_a" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-nat-ipaddress-a"
    "bashlinux:network-visibility" = "public"
  })
}

resource "aws_eip" "nat_b" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-nat-ipaddress-b"
    "bashlinux:network-visibility" = "public"
  })
}

# NAT Gateways
resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_1a.id

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-nat-gateway-a"
    "bashlinux:network-visibility" = "private"
  })
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_1b.id

  tags = merge(var.default_tags, {
    Name                        = "${var.organization}-${var.environment}-nat-gateway-b"
    "bashlinux:network-visibility" = "private"
  })
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-public-route-table"
    "bashlinux:network-visibility" = "public"
  })
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.main.id
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-private-route-table-a"
    "bashlinux:network-visibility" = "private"
  })
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_b.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.main.id
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-private-route-table-b"
    "bashlinux:network-visibility" = "private"
  })
}

# Route Table Associations
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2a" {
  subnet_id      = aws_subnet.public_2a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2b" {
  subnet_id      = aws_subnet.public_2b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "private_2a" {
  subnet_id      = aws_subnet.private_2a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_2b" {
  subnet_id      = aws_subnet.private_2b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "private_3a" {
  subnet_id      = aws_subnet.private_3a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_3b" {
  subnet_id      = aws_subnet.private_3b.id
  route_table_id = aws_route_table.private_b.id
}

# Network ACLs
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  # Inbound rules
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "::/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 103
    action     = "allow"
    cidr_block = "::/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 104
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 105
    action     = "allow"
    cidr_block = "::/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 106
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1194
    to_port    = 1194
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 107
    action     = "allow"
    cidr_block = "::/0"
    from_port  = 1194
    to_port    = 1194
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 108
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 109
    action     = "allow"
    cidr_block = "::/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Outbound rules
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  egress {
    protocol   = "-1"
    rule_no    = 101
    action     = "allow"
    cidr_block = "::/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-public-acl"
    "bashlinux:network-visibility" = "public"
  })
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id

  # Inbound rules
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "-1"
    rule_no    = 101
    action     = "allow"
    cidr_block = "::/0"
    from_port  = 0
    to_port    = 65535
  }

  # Outbound rules
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  egress {
    protocol   = "-1"
    rule_no    = 101
    action     = "allow"
    cidr_block = "::/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-private-acl"
  })
}

# Network ACL Associations
resource "aws_network_acl_association" "public_1a" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public_1a.id
}

resource "aws_network_acl_association" "public_1b" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public_1b.id
}

resource "aws_network_acl_association" "public_2a" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public_2a.id
}

resource "aws_network_acl_association" "public_2b" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public_2b.id
}

resource "aws_network_acl_association" "private_1a" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private_1a.id
}

resource "aws_network_acl_association" "private_1b" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private_1b.id
}

resource "aws_network_acl_association" "private_2a" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private_2a.id
}

resource "aws_network_acl_association" "private_2b" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private_2b.id
}

resource "aws_network_acl_association" "private_3a" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private_3a.id
}

resource "aws_network_acl_association" "private_3b" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private_3b.id
}

# Placement Group
resource "aws_placement_group" "hpc" {
  name     = "${var.organization}-${var.environment}-placement-group"
  strategy = "cluster"

  tags = var.default_tags
}

# Route53 Private Hosted Zone
resource "aws_route53_zone" "private" {
  name = var.domain_name

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = merge(var.default_tags, {
    Name = var.domain_name
    "bashlinux:network-visibility" = "private"
  })
}

# DHCP Options
resource "aws_vpc_dhcp_options" "main" {
  domain_name         = var.domain_name
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = merge(var.default_tags, {
    "bashlinux:network-visibility" = "private"
  })
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}
