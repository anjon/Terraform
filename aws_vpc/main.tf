module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.2.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnets
  private_subnet_names = ["private-eu-central-1a", "private-eu-central-1b", "private-eu-central-1c"]
  private_subnet_tags = {
    subnet                            = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }

  public_subnets      = var.public_subnets
  public_subnet_names = ["public-eu-central-1a", "public-eu-central-1b", "public-eu-central-1c"]
  public_subnet_tags = {
    subnet                   = "public"
    "kubernetes.io/role/elb" = "1"
  }

  map_public_ip_on_launch = true
  enable_vpn_gateway      = true
  single_nat_gateway      = true
  one_nat_gateway_per_az  = false
  enable_nat_gateway      = true
  nat_gateway_tags = {
    "Name" = "k8s-natgw"
  }


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

