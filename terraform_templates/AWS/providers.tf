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
    bucket = "marble-terraform-deployment" // Bucket for storing terraform state
    key    = "marble"                      // State file name
    region = "us-east-2"                   // Bucket Region
  }
}

provider "aws" {
  region     = var.aws_region
  profile     = var.aws_profile
}
