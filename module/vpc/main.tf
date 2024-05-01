# create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true
  enable_dns_support =  true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet pub_sub_1a
resource "aws_subnet" "pub_sub_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_1a_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "pub_sub_1a"
  }
}

# create public subnet pub_sub_1b
resource "aws_subnet" "pub_sub_1b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_2b_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "pub_sub_1b"
  }
}

# create public subnet pub_sub_1c
resource "aws_subnet" "pub_sub_1c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_1c_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[2]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "pub_sub_1c"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "Public-rt"
  }
}

# associate public subnet pub-sub-1a to public route table
resource "aws_route_table_association" "pub-sub-1a_route_table_association" {
  subnet_id           = aws_subnet.pub_sub_1a.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet pub-sub-1b to public route table
resource "aws_route_table_association" "pub-sub-1b_route_table_association" {
  subnet_id           = aws_subnet.pub_sub_1b.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet pub-sub-1c to public route table
resource "aws_route_table_association" "pub-sub-1c_route_table_association" {
  subnet_id           = aws_subnet.pub_sub_1c.id
  route_table_id      = aws_route_table.public_route_table.id
}

# create private app subnet pri-sub-1a
resource "aws_subnet" "pri_sub_1a" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_1a_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "pri-sub-1a"
  }
}

# create private app pri-sub-1b
resource "aws_subnet" "pri_sub_1b" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_1b_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "pri-sub-1b"
  }
}

# create private data subnet pri-sub-1c
resource "aws_subnet" "pri_sub_1c" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_1c_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "pri-sub-1c"
  }
}

# Allocate Elastic IP Address
resource "aws_eip" "eip-nat-a" {
  vpc    = true

  tags   = {
    Name = "eip-nat-a"
  }
}

# create nat gateway
resource "aws_nat_gateway" "nat-a" {
  allocation_id = aws_eip.eip-nat-a.id
  subnet_id     = var.pub_sub_1a_id

  tags   = {
    Name = "nat-a"
  }
}
