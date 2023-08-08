# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    "Name" = "${var.project_name}-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    "Name" = "${var.project_name}-igw"
  }
}

# Use data source to get all availability zones in region
data "aws_availability_zones" "availability_zones" {}

# Create 1st public subnet
resource "aws_subnet" "sub_az_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_az_a_cidr
  availability_zone       = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public_subnet_az_a"
  }
}

#Create 2nd public subnet
resource "aws_subnet" "sub_az_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_az_b_cidr
  availability_zone       = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public_subnet_az_b"
  }
}

# Create Route Table and public rout
resource "aws_route_table" "main_vpc_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_block_any
    gateway_id = aws_internet_gateway.web_igw.id
  }

  tags = {
    "Name" = "Route to internet"
  }
}

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.sub_az_a.id
  route_table_id = aws_route_table.main_vpc_rt.id
}

resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.sub_az_b.id
  route_table_id = aws_route_table.main_vpc_rt.id
}
