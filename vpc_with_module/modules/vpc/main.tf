# Create VPC
resource "aws_vpc" "dev_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    tags = {
      "Name" = "dev-vpc" 
    }
}

# Create 2 Subnets
resource "aws_subnet" "subnets" {
  count = length(var.subnet_cidr)
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = var.subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.availabile.names[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    "Name" = var.subnet_names[count.index]
  }
}

# Create Internet-Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "Dev-igw"
  }
}

# Create Route-Table
resource "aws_route_table" "dev_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "DevRouteTable"
  }

}

# Create Route-Table Association
resource "aws_route_table_association" "dev_rta" {
  count = length(var.subnet_cidr)
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.dev_rt.id
}