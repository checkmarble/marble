/*
 * Code to identify providers
 */

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  // TO BE CHANGED TO YOUR OWN S3 BUCKET NAME
  backend "s3" {
    bucket = "pixpay-terraform" // Bucket for storing terraform state
    key    = "marble" // State file name
    region = "eu-west-3" // Bucket Region
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

