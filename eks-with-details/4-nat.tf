resource "aws_eip" "eks_eip" {
  vpc = true

  tags = {
    Name = "eks-eip"
  }
}

resource "aws_nat_gateway" "eks_natgw" {
  allocation_id = aws_eip.eks_eip.id
  subnet_id     = aws_subnet.public_eu_central_1a.id

  tags = {
    Name = "eks-natgw"
  }

  depends_on = [aws_internet_gateway.eks_igw]
}