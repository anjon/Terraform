// Creating the VPC
resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

// Creating the Subnet
resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags = {
    Name = "dev-public"
  }
}

// Creating the Internet Gateway
resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    "Name" = "dev-igw"
  }
}

// Creating a Routing Table
resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id
  tags = {
    "Name" = "dev_public_rt"
  }
}

// Add routing table to the route
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

// Add Routing table to the subnet
resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id
}

// Creating Security Group 
resource "aws_security_group" "mtc_sg" {
  name        = "dev_sg"
  description = "Dev Security group"
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress = [{
    description      = "Inbound Trafic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  egress = [{
    description      = "Outbound Trafic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]
}

// Adding the authentication 
resource "aws_key_pair" "mtc_auth" {
  key_name = "mtc_key"
  public_key = file("/Users/anjon/.ssh/mtc_key.pub")
}

// Creating the Instance
resource "aws_instance" "dev_node" {
  instance_type =  "t2.micro"
  ami = data.aws_ami.server_ami.id
  key_name = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id = aws_subnet.mtc_public_subnet.id
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    "Name" = "Dev_Node"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname = self.public_ip,  
      user = "ubuntu", 
      identityfile = "/Users/anjon/.ssh/mtc_key"
    })
    interpreter = var.host_os == "mac" ? ["bash", "-c"] : ["Powershell", "-Command"]
  }

}