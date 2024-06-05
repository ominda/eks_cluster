# Create Internet Gateway
resource "aws_internet_gateway" "r_internet_gateway" {
  vpc_id = aws_vpc.r_vpc.id

  tags = {
    Name = "${local.base_name}_igw"
  }
}

# Create EIP
resource "aws_eip" "r_elastic_ip" {
  domain = "vpc"
}

# Create NAT Gateway
resource "aws_nat_gateway" "r_nat_gateway" {
  connectivity_type = "public"
  allocation_id     = aws_eip.r_elastic_ip.id
  subnet_id         = aws_subnet.r_public_subnets[0].id

  tags = {
    Name = "${local.base_name}_nat_gateway"
  }
  depends_on = [aws_internet_gateway.r_internet_gateway]
}