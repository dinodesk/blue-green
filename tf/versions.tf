terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Keep provider configuration centralized so root modules only declare infrastructure.
provider "aws" {
  region = var.aws_region
}
