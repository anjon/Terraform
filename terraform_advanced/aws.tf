provider "aws" {
  access_key = "ZKIAITH7YUGAZZIYYSZA"
  secret_key = "UlNapYqUCg2m4MDPT9Tlq+64BWnITspR93fMNc0Y"
  region = "ap-southeast-1"
}

resource "aws_instance" "example" {
  ami = "ami-83a713e0"
  instance_type = "t2.micro"
  tags {
    Name = "your-instance"
  }
}
