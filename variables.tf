variable "project" {
  type        = string
  description = "Project Name"
  default = "komettest"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile to use for credentials"
  default = "komet"
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
  default = "us-east-2"
  type    = string
}

variable "db_username" {
  description = "RDS user name"
  type        = string
  default = "panda"
}


variable "db_password" {
  description = "RDS user password"
  type        = string
  sensitive   = true
}

variable "frontend_tag" {
  description = "Front-end repository tag"
  type        = string
  default = "v1.0.3"
}

variable "backend_tag" {
  description = "Back-end repository tag"
  type        = string
  default = "v1.1.2"
}

variable "landing_tag" {
  description = "Landing repository tag"
  type        = string
  default = "v1.0.2"
}
