variable "project" {
  type        = string
  description = "Project Name"
}

variable "api_path" {
  type        = string
  description = "API path"
  default     = "/api/v1"
}

variable "environment" {
  default = "testing"
  type    = string
}

variable "region" {
  default = "us-east-2"
  type    = string
}

variable "db_password" {
  description = "RDS user password"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "RDS username"
  type        = string
  sensitive   = true
}


variable "frontend_tag" {
  description = "Front-end repository tag"
  type        = string
}

variable "backend_tag" {
  description = "Back-end repository tag"
  type        = string
}
