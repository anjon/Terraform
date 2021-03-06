# This is the main.tf
#-----------------------------------------------------------------------#
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
  access_key = "xxxxxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxxxxx"
}

variable "subnet_prefix" {
  description = "cidr block for the subnet"
}

# 1. Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    "Name" = "production"
  }
}
# 2. Create a Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = var.subnet_prefix[0].cidr_block
  availability_zone = "us-east-1a"
  tags = {
    "Name" = var.subnet_prefix[0].name
  }
}

# 3. Create another subnet
resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = var.subnet_prefix[1].cidr_block
  availability_zone = "us-east-1a"
  tags = {
    "Name" = var.subnet_prefix[1].name
  }
}

#-----------------------------------------------------------------------#


# This is the terraform.tfvars
#-----------------------------------------------------------------------#
subnet_prefix = [{cidr_block = "10.0.1.0/24", name = "prod_subnet"}, {cidr_block = "10.0.2.0/24", name = "dev_subnet"}]
#-----------------------------------------------------------------------#
