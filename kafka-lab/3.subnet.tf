// Creating Private Subnets
resource "aws_subnet" "private_eu_central_1a" {
  vpc_id            = aws_vpc.kafka_vpc.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "eu-central-1a"
  #map_public_ip_on_launch = true
}

resource "aws_subnet" "private_eu_central_1b" {
  vpc_id            = aws_vpc.kafka_vpc.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "eu-central-1b"
  #map_public_ip_on_launch = true
}

resource "aws_subnet" "private_eu_central_1c" {
  vpc_id            = aws_vpc.kafka_vpc.id
  cidr_block        = "10.0.64.0/19"
  availability_zone = "eu-central-1c"
  #map_public_ip_on_launch = true
}