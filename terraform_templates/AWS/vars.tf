/*
 * Code to declare the variables for terraform
 */

variable "aws_access_key_id" {
  type        = string
}

variable "aws_secret_access_key" {
  type        = string
}

variable "aws_region" {
  type        = string
  description = "AWS Region to use"
  default     = "eu-west-3" // TO BE CHANGED
}


variable "aws_zones" {
  type        = list(string)
  description = "List of availability zones to use"
  default     = ["eu-west-3a", "eu-west-3b"] // TO BE CHANGED
}

variable "aws_key_pair" {
  type        = string
  description = "Name of the Key pair (used for SSH Access to EC2)"
  default     = "nklein" // TO BE CHANGED with the name of the key pair
}

variable "domain" {
  type        = string
  description = "Domain associated with the site (An SSL Certificate must be associated to this domain *)"
  default     = "*.pixpay.app" // TO BE CHANGED
}