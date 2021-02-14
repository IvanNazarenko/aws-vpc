variable "vpc_name" {
  type = string
  description = "name of VPC"
}

variable "internet_gw_name" {
  type = string
  description = "mane of internet gateway"
}

variable "nat_gw_name" {
  type = string
  description = "mane of nat gateway"
}

variable "public_subnet_a_name" {
  type = string
  description = "mane of publuc subnet a"
}

variable "public_subnet_b_name" {
  type = string
  description = "mane of publuc subnet b"
}