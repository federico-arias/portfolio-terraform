variable "service_name" {
  type        = string
  description = "The name of the AWS Lambda function"
}

variable "source_dir" {
  type        = string
  description = "The path of the source folder for the function"
}

variable "timeout" {
  type        = number
  description = "(Optional) Amount of time your Lambda Function has to run in seconds. Defaults to 3"
  default = 3
}


variable "env_variables" {
  type        = map
  description = "The env variables to pass to the function code"
}

variable "api_id" {
  type        = string
  description = "The ID of the API Gateway this lambda function is connected to"
}

variable "api_execution_arn" {
  type        = string
  description = "The execution ARN of the API Gateway this lambda function is connected to"
}

variable "private_subnets" {
  type        = list
  description = "Subnets"
}

variable "security_group_ids" {
  type        = list
  description = "Security groups"
}

variable "method" {
  type        = string
  description = "HTTP Request method"
  default = "GET"
}

variable "path" {
  type        = string
  description = "The path that leads to call the function"
  default = "/"
}
