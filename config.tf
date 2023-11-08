terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.64"
    }
  }
}

provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"

  default_tags {
    tags = {
      "Terraform" = "True"
    }
  }
}

