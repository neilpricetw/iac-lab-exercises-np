variable "prefix" {
  type = string
  description = "Prefix identifier"
}

variable "region" {
  type = string
  description = "Region"
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR block"
}
variable "number_of_public_subnets" {
  description = "Number of public subnets in the VPC"
  type        = number
}

variable "number_of_private_subnets" {
  description = "Number of private subnets in the VPC"
  type        = number
}

variable "number_of_secure_subnets" {
  description = "Number of secure subnets in the VPC"
  type        = number
}