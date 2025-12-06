resource "aws_vpc" "vpc1" {
  cidr_block = "192.168.0.0/16"
  instance_tenancy = "default"
#   enable_dns_hostnames = true
#   enable_dns_support = true
  tags = {
    Name = "Terraform-vpc"
    Env = "Dev"
    Team = "DevOps"
  }
}

resource "aws_internet_gateway" "gateway1" {
  vpc_id = aws_vpc.vpc1.id
}

#Public Subnets

resource "aws_subnet" "public1" {
  availability_zone = "us-east-1a"
  cidr_block = "192.168.1.0/24"
  vpc_id = aws_vpc.vpc1.id 
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet1"
    Env = "Dev"
  }
}

resource "aws_subnet" "public2" {
  availability_zone = "us-east-1b"
  cidr_block = "192.168.2.0/24"
  vpc_id = aws_vpc.vpc1.id 
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet2"
    Env = "Dev"
  }
}

#Private Subnets

resource "aws_subnet" "Private1" {
  availability_zone = "us-east-1a"
  cidr_block = "192.168.3.0/24"
  vpc_id = aws_vpc.vpc1.id 
  tags = {
    Name = "private-subnet1"
    Env = "Dev"
  }
}

resource "aws_subnet" "Private2" {
  availability_zone = "us-east-1b"
  cidr_block = "192.168.4.0/24"
  vpc_id = aws_vpc.vpc1.id 
  tags = {
    Name = "private-subnet2"
    Env = "Dev"
  }
}

#Elastic ip and NAT Gateway
resource "aws_eip" "eip" {
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public1.id
}

#Public Route Table

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }
}

#Private Route Table

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
}

#Subnet Association

resource "aws_route_table_association" "route1" {
  subnet_id = aws_subnet.Private1.id
  route_table_id = aws_route_table.private_route.id 
}
resource "aws_route_table_association" "route2" {
  subnet_id = aws_subnet.Private2.id
  route_table_id = aws_route_table.private_route.id 
}
resource "aws_route_table_association" "route3" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.public_route.id
}
resource "aws_route_table_association" "route4" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.public_route.id
}