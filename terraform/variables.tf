variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "env" {
  type    = string
  default = "demo"
}

variable "vpc_name" {
  type    = string
  default = "vpc"
}

variable "private_subnets" {
  default = {
    "private_subnet-1" = { cidr_index = 1, az_index = 0 }
    "private_subnet-2" = { cidr_index = 2, az_index = 1 }
    "private_subnet-3" = { cidr_index = 3, az_index = 2 }
  }
}

variable "public_subnets" {
  default = {
    "public_subnet-1" = { cidr_index = 10, az_index = 0 }
    "public_subnet-2" = { cidr_index = 11, az_index = 1 }
    "public_subnet-3" = { cidr_index = 12, az_index = 2 }
  }
}

