// Creating private Routing table 
resource "aws_route_table" "eks_private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      nat_gateway_id             = aws_nat_gateway.eks_nat.id
      carrier_gateway_id         = ""
      core_network_arn           = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = ""
      instance_id                = ""
      ipv6_cidr_block            = "::/0"
      local_gateway_id           = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = "private"
  }
}

// Creating Public Routing Table
resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.eks_igw.id
      carrier_gateway_id         = ""
      core_network_arn           = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = "::/0"
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = "public"
  }
}

// Routing table association for private route
resource "aws_route_table_association" "private_eu_central_1a" {
  subnet_id      = aws_subnet.private_eu_central_1a.id
  route_table_id = aws_route_table.eks_private_rt.id
}
resource "aws_route_table_association" "private_eu_central_1b" {
  subnet_id      = aws_subnet.private_eu_central_1b.id
  route_table_id = aws_subnet.private_eu_central_1b.id
}

// Routing table association for Public Route
resource "aws_route_table_association" "public_eu_central_1a" {
  subnet_id      = aws_subnet.public_eu_central_1a.id
  route_table_id = aws_subnet.public_eu_central_1a.id
}
resource "aws_route_table_association" "public_eu_central_1b" {
  subnet_id      = aws_subnet.public_eu_central_1b.id
  route_table_id = aws_subnet.public_eu_central_1b.id
}