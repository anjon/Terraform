# Creating 3 node AWS-EC2 instance for docker swarm 
resource "aws_instance" "docker_server" {
  ami = "ami-00068cd7555f543d5"
  count = 3
  key_name = "my-ec2"
  instance_type = "t2.micro"
  security_groups = [ "docker_swarm"]
  associate_public_ip_address = "true"
  tags = {
    Name = "docker_node_${count.index}"
  }
}

# Creating security group for docker swarm with required port
resource "aws_security_group" "docker_swarm" {
  name = "docker_swarm"
  description = "docker_swarm"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2376
    to_port     = 2376
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags= {
    Name = "docker_swarm"
  }

# Outbound from server which is default configuration
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }

}
