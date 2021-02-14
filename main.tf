provider "aws" {
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = var.internet_gw_name
  }
}

resource "aws_subnet" "public_subnet_a" {
  cidr_block = "10.0.11.0/24"
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = "us-east-2a"
  ## set every host in subnet public IP
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_a_name
  }
}

resource "aws_subnet" "public_subnet_b" {
  cidr_block = "10.0.21.0/24"
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_b_name
  }
}

resource "aws_route_table" "route_table_for_public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  gateway_id = aws_internet_gateway.internet_gw
  subnet_id = ["aws_subnet.public_subnet_a", "aws_subnet.public_subnet_b"]
}



#resource "aws_nat_gateway" "nat_gw" {
#  allocation_id = ""
#  subnet_id = ""
#}