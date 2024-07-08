terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63.0"
    }
  }
}

 provider "aws" {
   access_key = "xxxxxxxxxx"
   secret_key = "xxxxxxxxxx"
   region     = "us-east-1"
 }
