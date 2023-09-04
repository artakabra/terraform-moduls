# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr["${terraform.workspace}"]
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    "Name" = "${terraform.workspace}-${var.project_name}-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    "Name" = "${terraform.workspace}-${var.project_name}-igw"
  }
}

# Create 1st public subnet
resource "aws_subnet" "sub_az_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_az_a_cidr["${terraform.workspace}"]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${terraform.workspace}-public_subnet_az_a"
  }
}

# Create 2nd public subnet
resource "aws_subnet" "sub_az_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_az_b_cidr["${terraform.workspace}"]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${terraform.workspace}-public_subnet_az_b"
  }
}
