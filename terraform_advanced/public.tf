resource "aws_subnet" "public-subnet-in-ap-southeast-1" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "ap-southeast-1a"
  tags {
    Name = "Linoxide Public Subnet"
  }
}
