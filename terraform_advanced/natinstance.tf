resource "aws_instance" "nat" {
  ami = "ami-1a9dac48" # this is a special ami preconfigured to do NAT
  availability_zone = "ap-southeast-1a"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"] 
  subnet_id = "${aws_subnet.public-subnet-in-ap-southeast-1.id}"
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "NAT instance"
  }

}
