provider "aws" {
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}

#resource "aws_internet_gateway" "internet_gw" {
#  vpc_id = aws_vpc.main_vpc.id
#  tags = {
#    Name = var.internet_gw_name
#  }
#}
#
#resource "aws_subnet" "public_subnet_a" {
#  cidr_block = "10.0.11.0/24"
#  vpc_id = aws_vpc.main_vpc.id
#  availability_zone = "us-east-1a"
#  ## set every host in subnet public IP
#  map_public_ip_on_launch = true
#  tags = {
#    Name = var.public_subnet_a_name
#  }
#}
#
#resource "aws_subnet" "public_subnet_b" {
#  cidr_block = "10.0.21.0/24"
#  vpc_id = aws_vpc.main_vpc.id
#  availability_zone = "us-east-1b"
#  map_public_ip_on_launch = true
#  tags = {
#    Name = var.public_subnet_b_name
#  }
#}
#
#resource "aws_route_table" "route_table_for_public_subnet" {
#  vpc_id = aws_vpc.main_vpc.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.internet_gw.id
#  }
#}
#
#resource "aws_route_table_association" "attach_RT_public_b" {
#  subnet_id = aws_subnet.public_subnet_a.id
#  route_table_id = aws_route_table.route_table_for_public_subnet.id
#}
#
#
#resource "aws_route_table_association" "attach_RT_public_a" {
#  subnet_id = aws_subnet.public_subnet_b.id
#  route_table_id = aws_route_table.route_table_for_public_subnet.id
#}
#
#resource "aws_subnet" "private_subnet_a" {
#  cidr_block = "10.0.12.0/24"
#  vpc_id = aws_vpc.main_vpc.id
#  availability_zone = "us-east-1a"
#  tags = {
#    Name = var.private_subnet_a_name
#  }
#}
#
#resource "aws_subnet" "private_subnet_b" {
#  cidr_block = "10.0.22.0/24"
#  vpc_id = aws_vpc.main_vpc.id
#  availability_zone = "us-east-1b"
#  tags = {
#    Name = var.private_subnet_b_name
#  }
#}
#
#resource "aws_eip" "eip_gw_a" {
#  vpc = true
#}
#
#resource "aws_eip" "eip_gw_b" {
#  vpc = true
#}
#
#resource "aws_nat_gateway" "nat_gw_a" {
#  allocation_id = aws_eip.eip_gw_a.id
#  subnet_id = aws_subnet.public_subnet_a.id
#  tags = {
#    Name = var.nat_gw_a_name
#  }
#  depends_on = [aws_eip.eip_gw_a]
#}
#
#resource "aws_nat_gateway" "nat_gw_b" {
#  allocation_id = aws_eip.eip_gw_b.id
#  subnet_id = aws_subnet.public_subnet_b.id
#  tags = {
#    Name = var.nat_gw_b_name
#  }
#  depends_on = [aws_eip.eip_gw_b]
#}
#
#resource "aws_route_table" "route_table_for_private_subnet_a" {
#  vpc_id = aws_vpc.main_vpc.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_nat_gateway.nat_gw_a.id
#  }
#}
#
#resource "aws_route_table" "route_table_for_private_subnet_b" {
#  vpc_id = aws_vpc.main_vpc.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_nat_gateway.nat_gw_b.id
#  }
#}
#
#resource "aws_route_table_association" "attach_RT_private_a" {
#  subnet_id = aws_subnet.private_subnet_a.id
#  route_table_id = aws_route_table.route_table_for_private_subnet_a.id
#}
#
#resource "aws_route_table_association" "attach_RT_private_b" {
#  subnet_id = aws_subnet.private_subnet_b.id
#  route_table_id = aws_route_table.route_table_for_private_subnet_b.id
#}
#
#resource "aws_subnet" "db_subnet_a" {
#  cidr_block = "10.0.13.0/24"
#  vpc_id = aws_vpc.main_vpc.id
#  tags = {
#    Name = var.db_subnet_a_name
#  }
#}
#
#
#resource "aws_subnet" "db_subnet_b" {
#  cidr_block = "10.0.23.0/24"
#  vpc_id = aws_vpc.main_vpc.id
#  tags = {
#    Name = var.db_subnet_b_name
#  }
#}
#
#resource "aws_route_table" "route_table_for_db_subnet_a" {
#  vpc_id = aws_vpc.main_vpc.id
#}
#
#resource "aws_route_table" "route_table_for_db_subnet_b" {
#  vpc_id = aws_vpc.main_vpc.id
#}
#
#resource "aws_route_table_association" "attach_RT_db_a" {
#  route_table_id = aws_route_table.route_table_for_db_subnet_a.id
#  subnet_id = aws_subnet.db_subnet_a.id
#}
#
#resource "aws_route_table_association" "attach_RT_db_b" {
#  route_table_id = aws_route_table.route_table_for_db_subnet_b.id
#  subnet_id = aws_subnet.db_subnet_b.id
#}
#

########################################
##            Create ASG             ##
########################################

resource "aws_key_pair" "wayne" {
  key_name = "wayne-key"
  public_key = file("id_rsa.pub")
}

resource "aws_security_group" "bastion" {
  name = "bastion"
  description = "open-ssh"
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port = 0
    protocol = "tcp"
    to_port = 22
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_launch_template" "basion" {
  image_id = "ami-03d315ad33b9d49c4"
  instance_type = "t2.micro"
  name = "ubuntu-minimal"
  key_name = aws_key_pair.wayne.key_name
  security_group_names = [aws_security_group.bastion.name]
  block_device_mappings {
    ebs {
      volume_size = 20
    }
  }
}


resource "aws_autoscaling_group" "bastion" {
  name = "Ansible-host"
  launch_configuration = aws_launch_template.basion.name
  availability_zones = ["us-east-1a","us-east-1b"]
  desired_capacity = 1
  min_size = 1
  max_size = 1
  depends_on = [aws_launch_template.basion]
}