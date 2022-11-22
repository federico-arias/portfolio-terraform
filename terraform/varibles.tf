variable "project" {
  type        = string
  description = "Project Name"
}

variable "domain" {
  type        = string
  description = "DNS Domain"
}

variable "subdomain" {
  type = string
}

variable "aws_profile" {
  type        = string
  description = "AWS profile to use for credentials"
}

variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "aws_lb_url" {
  description = "Configuration after the cluster is created to point DNS records to"
  type    = string
}
