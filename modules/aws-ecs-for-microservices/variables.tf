variable "service_name" {
  type        = string
  description = "Project Name"
  default = "komettest"
}

variable "service_tag" {
  type        = string
  description = "Project Name"
  default = "komettest"
}


variable "vpc_id" {
  type        = string
  description = "Project Name"
  default = "komettest"
}

variable "healthcheck_path" {
  type        = string
  description = "Project Name"
  default = "komettest"
}

variable "path_pattern" {
  type        = string
  description = "Project Name"
  default = "komettest"
}

variable "loadbalancer_listener_arn" {
  type        = string
  description = "LoadBalancer listener"
  default = "komettest"
}

variable "environment_variables" {
  type = list(map)
  description = "Environment variables to inject into the container"
}
