variable "vpc_name" {
  type = string
  description = "name of VPC"
}

variable "internet_gw_name" {
  type = string
  description = "mane of internet gateway"
}

variable "nat_gw_a_name" {
  type = string
  description = "mane of nat gateway a"
}

variable "nat_gw_b_name" {
  type = string
  description = "mane of nat gateway b"
}

variable "public_subnet_a_name" {
  type = string
  description = "mane of public subnet a"
}

variable "public_subnet_b_name" {
  type = string
  description = "mane of public subnet b"
}

variable "private_subnet_a_name" {
  type = string
  description = "mane of private subnet a"
}

variable "private_subnet_b_name" {
  type = string
  description = "mane of private subnet b"
}