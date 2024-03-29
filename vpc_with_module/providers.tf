terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "terraform-remote-backend-s3-anjon"
    key    = "dev/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region                   = "eu-central-1"
}