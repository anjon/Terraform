terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
}

provider "aws" {
  region                   = "eu-central-1"
  shared_credentials_files = ["/Users/anjon/.aws/credentials"]
  profile                  = "vscode"
}