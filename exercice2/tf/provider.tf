terraform {
  required_version = "> 1.5, < 2"
  #  backend "s3" {
  #  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      Region = "eu-west-1"
    }
  }
}
