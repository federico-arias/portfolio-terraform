variable "project" {
  type        = string
  description = "Project Name"
}

variable "domain" {
  type        = string
  description = "DNS Domain"
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

variable "db_username" {
  description = "RDS user name"
  type        = string
  default     = "panda"
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
