// Creating internet-gateway for eks-vpc
resource "aws_internet_gateway" "kafka_igw" {
  vpc_id = aws_vpc.kafka_vpc.id

  tags = {
    Name = "kafka-igw"
  }
}