variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}

variable "key_name" {
  description = "Key name of the key pair to be used for the instance."
  default     = null
  type        = string
}

variable "domain_name" {
  type = string
}

variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "wordpress-nginx"
}