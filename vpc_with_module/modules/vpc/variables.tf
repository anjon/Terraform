variable "vpc_cidr" {
    description = "VPC cidr range"
    type = string   
}

variable "subnet_cidr" {
  description = "Subnet CIDRs"
  type = list(string)
}

variable "subnet_names" {
  description = "Subnet Names"
  type = list(string)
  default = [ "public-subnet-01", "public-subnet-02" ]
}