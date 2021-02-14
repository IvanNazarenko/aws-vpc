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
  availability_zone = "us-east-1a"
  ## set every host in subnet public IP
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_a_name
  }
}

resource "aws_subnet" "public_subnet_b" {
  cidr_block = "10.0.21.0/24"
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_b_name
  }
}

resource "aws_route_table" "route_table_for_public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }
}

resource "aws_route_table_association" "attach_RT_public_b" {
  subnet_id = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.route_table_for_public_subnet.id
}


resource "aws_route_table_association" "attach_RT_public_a" {
  subnet_id = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.route_table_for_public_subnet.id
}

resource "aws_subnet" "private_subnet_a" {
  cidr_block = "10.0.12.0/24"
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = "us-east-1a"
  tags = {
    Name = var.private_subnet_a_name
  }
}

resource "aws_subnet" "private_subnet_b" {
  cidr_block = "10.0.22.0/24"
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = "us-east-1a"
  tags = {
    Name = var.private_subnet_b_name
  }
}

resource "aws_eip" "eip_gw_a" {
  vpc = true
}

resource "aws_eip" "eip_gw_b" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw_a" {
  allocation_id = aws_eip.eip_gw_a.id
  subnet_id = aws_subnet.public_subnet_a
  tags = {
    Name = var.nat_gw_a_name
  }
}

resource "aws_nat_gateway" "nat_gw_b" {
  allocation_id = aws_eip.eip_gw_b.id
  subnet_id = aws_subnet.public_subnet_b
  tags = {
    Name = var.nat_gw_b_name
  }
}

#resource "aws_route_table" "route_table_for_private_subnet" {
#  vpc_id = aws_vpc.main_vpc.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.internet_gw.id
#  }
#}

