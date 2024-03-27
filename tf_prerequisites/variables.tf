variable "prefix" {
  type        = string
  description = "Prefix to many of the resources created which helps as an identifier, could be company name, solution name, etc"
  default     = "np-iac-lab"
}

variable "region" {
  type        = string
  description = "Region to deploy the solution"
  default     = "ap-southeast-2"
}

variable "repo_name" {
  type        = string
  description = "Repo name"
  default     = "neilpricetw/iac-lab-exercises-np"
}
