variable "name" {
  type        = string
  description = "Project Name"
  default = "komettest"
}

variable "tag" {
  type        = string
  description = "Project Name"
}

variable "vpc_id" {
  type        = string
  description = "Project Name"
}

variable "healthcheck_path" {
  type        = string
  description = "Project Name"
}

variable "path_pattern" {
  type        = string
  description = "Project Name"
}

variable "loadbalancer_listener_arn" {
  type        = string
  description = "LoadBalancer listener"
}

variable "environment_variables" {
  type = list(map)
  description = "Environment variables to inject into the container"
}
