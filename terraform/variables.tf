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

variable "api_path" {
  type        = string
  description = "API path"
  default     = "/api/v1"
}

variable "environment" {
  default = "production"
  type    = string
}

variable "region" {
  type = string
}

variable "frontend_tag" {
  description = "Front-end repository tag"
  type        = string
}

variable "backend_tag" {
  description = "Back-end repository tag"
  type        = string
}

variable "landing_tag" {
  description = "Landing repository tag"
  type        = string
}
