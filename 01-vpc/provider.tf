terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 6.37.0"
    }
  }
backend "s3" {
  bucket = "linga-devops-rs"
  key = "expense-infra-standard-vpc"
  region = "us-east-1"
  #dynamodb_table = "roboshop13-locking"
  use_lockfile = true
  }
}
#provide authentication here
provider "aws" {
  # Configuration options
  region = "us-east-1"
}