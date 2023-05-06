// Creating Routing Table 
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "private-route"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "public-route"
  }
}

// Adding routing table to the route
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_natgw.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_igw.id
}
resource "aws_route_table_association" "private_eu_central_1a" {
  subnet_id      = aws_subnet.private_eu_central_1a.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_eu_central_1b" {
  subnet_id      = aws_subnet.private_eu_central_1b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public_eu_central_1a" {
  subnet_id      = aws_subnet.public_eu_central_1a.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_eu_central_1b" {
  subnet_id      = aws_subnet.public_eu_central_1b.id
  route_table_id = aws_route_table.public_rt.id
}