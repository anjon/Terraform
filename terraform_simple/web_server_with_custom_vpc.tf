terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIAIGPMBZQQPBXQNT2A"
  secret_key = "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"
}

# 1. Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    "Name" = "production"
  }
}
# 2. Create Internet Gateway
resource "aws_internet_gateway" "prod-gw" {
  vpc_id = aws_vpc.prod-vpc.id
}
# 3. Create Custom Routing Table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.prod-gw.id
  }
}
# 4. Create a Subnet 
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    "Name" = "prod-subnet"
  }
}
# 5. Associate Subnet with Routing Table 
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id 
}
# 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}
# 7. Create a Network Interface with an IP in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id 
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}
# 8. Assign an Elastic IP to the network interface created in step 7 
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  instance                  = aws_instance.web.id 
  depends_on                = [aws_internet_gateway.prod-gw]
}
# 9. Create Ubuntu Server and install/enable apache2
resource "aws_instance" "web" {
  ami           = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "my-ec2"
  
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id 
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y 
                sudo apt install apache2 -y
                sudo systemctl start apache2 
                sudo bash -c 'echo Welcome Anjon Web Server > /var/www/html/index.html'
            EOF
  tags = {
    Name = "Web-Server"
  }
}

output "server_public_ip" {
    value = aws_eip.one.public_ip
}

output "server_private_ip" {
    value = aws_instance.web-instance.private_ip
}

#terraform state list
#terraform state show aws.eip.one
#terraform state show aws_instance.web
#terraform destroy -target aws_instance.web
#terraform apply -target aws_instance.web
