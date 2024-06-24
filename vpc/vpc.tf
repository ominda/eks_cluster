# Create primary VPC
resource "aws_vpc" "r_vpc" {
  cidr_block = var.primary_cidr

  tags = {
    Name = "${local.base_name}_vpc"
  }
}

# Attach DB CIDR to the VPC.
resource "aws_vpc_ipv4_cidr_block_association" "r_vpc_cidrs" {
  for_each   = var.cidrs
  vpc_id     = aws_vpc.r_vpc.id
  cidr_block = each.value
}

# Create public subnets
resource "aws_subnet" "r_public_subnets" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.r_vpc.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${local.base_name}_PublicSubnet-0%d", count.index + 1)
  }
}

# Create Public LB subnets
resource "aws_subnet" "r_public_lb_subnets" {
  count             = length(var.public_lb_subnets)
  vpc_id            = aws_vpc.r_vpc.id
  cidr_block        = var.public_lb_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${local.base_name}_PublicLbSubnet-0%d", count.index + 1)
  }
}

# Create Control Plane subnets
resource "aws_subnet" "r_control_plane_subnets" {
  count             = length(var.control_plane_subnets)
  vpc_id            = aws_vpc.r_vpc.id
  cidr_block        = var.control_plane_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${local.base_name}_CtrlPlaneSubnet-0%d", count.index + 1)
  }
}

# Create Internal LB subnets
resource "aws_subnet" "r_internal_lb_subnets" {
  count             = length(var.internal_lb_subnets)
  vpc_id            = aws_vpc.r_vpc.id
  cidr_block        = var.internal_lb_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${local.base_name}_InternalLbSubnet-0%d", count.index + 1)
  }
}

# Create TGW subnets
resource "aws_subnet" "r_tgw_subnets" {
  count             = length(var.tgw_subnets)
  vpc_id            = aws_vpc.r_vpc.id
  cidr_block        = var.tgw_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${local.base_name}_TgwSubnet-0%d", count.index + 1)
  }
}

# Create Private NAT subnets
resource "aws_subnet" "r_private_nat_subnets" {
  count             = length(var.private_nat_subnets)
  vpc_id            = aws_vpc.r_vpc.id
  cidr_block        = var.private_nat_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${local.base_name}_PrivateNatSubnet-0%d", count.index + 1)
  }
}

# Create EFS subnets
resource "aws_subnet" "r_efs_subnets" {
  count             = length(var.efs_subnets)
  vpc_id            = aws_vpc.r_vpc.id
  cidr_block        = var.efs_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${local.base_name}_EfsSubnet-0%d", count.index + 1)
  }
}

# Create Utility subnets
resource "aws_subnet" "r_utility_subnets" {
  count             = length(var.utility_subnets)
  vpc_id            = aws_vpc.r_vpc.id
  cidr_block        = var.utility_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${local.base_name}_UtilitySubnet-0%d", count.index + 1)
  }
}

# Create DB subnets
resource "aws_subnet" "r_db_subnets" {
  count             = length(var.db_subnets)
  vpc_id            = aws_vpc.r_vpc.id
  cidr_block        = var.db_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${local.base_name}_DbSubnet-0%d", count.index + 1)
  }
}

# Create Node Group subnets
resource "aws_subnet" "r_node_group_subnets" {
  count             = length(var.node_group_subnets)
  vpc_id            = aws_vpc.r_vpc.id
  cidr_block        = var.node_group_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${local.base_name}_NodeGroupSubnet-0%d", count.index + 1)
  }
}

######################
#### Route Tables ####
######################
# Create public route table
resource "aws_route_table" "r_public_route_table" {
  vpc_id = aws_vpc.r_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.r_internet_gateway.id
  }

  tags = {
    Name = "${local.base_name}_public_rbt"
  }
}

# Create private route table
resource "aws_route_table" "r_private_route_table" {
  vpc_id = aws_vpc.r_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.r_nat_gateway.id
    # gateway_id = aws_nat_gateway.r_nat_gateway.id
  }
  # route {
  #   cidr_block = "172.16.0.0/12"
  #   # Transit Gateway attachment
  # }
  # route {
  #   cidr_block = "10.0.0.0/8"
  #   # Transit Gateway attachment
  # }
  # route {
  #   cidr_block = "192.168.0.0/16"
  #   # Transit Gateway attachment
  # }

  tags = {
    Name = "${local.base_name}_private_rbt"
  }
}

# Subnet, Route table association
resource "aws_route_table_association" "r_public_subnets_association" {
  # for_each = {aws_subnet.r_public_subnets : subnet.id => aws_subnet.r_public_subnets[subnet.id].cidr_block}
  count = length(var.public_subnets)
  # subnet_id      = aws_subnet.r_public_subnets[*].id
  route_table_id = aws_route_table.r_public_route_table.id
  subnet_id      = element(aws_subnet.r_public_subnets.*.id, count.index)
}

resource "aws_route_table_association" "r_public_lb_subnets_association" {
  count          = length(var.public_lb_subnets)
  route_table_id = aws_route_table.r_public_route_table.id
  subnet_id      = element(aws_subnet.r_public_subnets.*.id, count.index)
}

resource "aws_route_table_association" "r_control_plane_subnets_association" {
  count          = length(var.control_plane_subnets)
  subnet_id      = element(aws_subnet.r_control_plane_subnets.*.id, count.index)
  route_table_id = aws_route_table.r_private_route_table.id
}

resource "aws_route_table_association" "r_internal_lb_subnets_association" {
  count          = length(var.internal_lb_subnets)
  subnet_id      = element(aws_subnet.r_internal_lb_subnets.*.id, count.index)
  route_table_id = aws_route_table.r_private_route_table.id
}

resource "aws_route_table_association" "r_tgw_subnets_association" {
  count          = length(var.tgw_subnets)
  subnet_id      = element(aws_subnet.r_tgw_subnets.*.id, count.index)
  route_table_id = aws_route_table.r_private_route_table.id
}

resource "aws_route_table_association" "r_private_nat_subnets_association" {
  count          = length(var.private_nat_subnets)
  subnet_id      = element(aws_subnet.r_private_nat_subnets.*.id, count.index)
  route_table_id = aws_route_table.r_private_route_table.id
}

resource "aws_route_table_association" "r_efs_subnets_association" {
  count          = length(var.efs_subnets)
  subnet_id      = element(aws_subnet.r_efs_subnets.*.id, count.index)
  route_table_id = aws_route_table.r_private_route_table.id
}

resource "aws_route_table_association" "r_utility_subnets_association" {
  count          = length(var.utility_subnets)
  subnet_id      = element(aws_subnet.r_utility_subnets.*.id, count.index)
  route_table_id = aws_route_table.r_private_route_table.id
}

resource "aws_route_table_association" "r_db_subnets_association" {
  count          = length(var.db_subnets)
  subnet_id      = element(aws_subnet.r_db_subnets.*.id, count.index)
  route_table_id = aws_route_table.r_private_route_table.id
  depends_on = [ 
    aws_subnet.r_db_subnets,
    aws_route_table.r_private_route_table
   ]
}

resource "aws_route_table_association" "r_node_group_subnets_association" {
  count          = length(var.node_group_subnets)
  subnet_id      = element(aws_subnet.r_node_group_subnets.*.id, count.index)
  route_table_id = aws_route_table.r_private_route_table.id
}