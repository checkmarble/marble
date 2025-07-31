/*
 * Code to declare the variables for terraform
 */

 variable "aws_profile" {
  type        = string
  description = "Default AWS Profile to use"
  default     = "rattrap" // TO BE CHANGED
}

variable "aws_region" {
  type        = string
  description = "AWS Region to use"
  default     = "us-east-2" // TO BE CHANGED
}


variable "aws_zones" {
  type        = list(string)
  description = "List of availability zones to use"
  default     = ["us-east-2a", "us-east-2b"] // TO BE CHANGED
}

variable "aws_key_pair" {
  type        = string
  description = "Name of the Key pair (used for SSH Access to EC2)"
  default     = "nklein" // TO BE CHANGED with the name of the key pair
}

variable "domain" {
  type        = string
  description = "Domain associated with the site (An SSL Certificate must be associated to this domain *)"
  default     = "*.rattrap.com" // TO BE CHANGED
}
