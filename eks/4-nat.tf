// Creating eip for NAT Gateway
resource "aws_eip" "eks_eip" {
  vpc = true

  tags = {
    Name = "eks-nat"
  }
}

// Associate eip to nat gateway
resource "aws_nat_gateway" "eks_nat" {
  allocation_id = aws_eip.eks_eip.id
  subnet_id     = aws_subnet.private_eu_central_1a.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.eks_igw]
}