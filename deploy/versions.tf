terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider configuration for AWS
provider "aws" {
  region = "eu-west-3"

  default_tags {
    tags = {
        Name = "hf-model-deployment"
    }
  }
}