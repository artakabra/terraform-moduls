# allocate elastic ip. this eip will be used for the nat-gateway in the az1
resource "aws_eip" "eip_for_nat_gateway_az1" {
  vpc    = true

  tags   = {
    Name = "${terraform.workspace}_nat gateway az1 eip"
  }
}

# allocate elastic ip. this eip will be used for the nat-gateway in the az2
resource "aws_eip" "eip_for_nat_gateway_az2" {
  vpc    = true

  tags   = {
    Name = "${terraform.workspace}_nat gateway az2 eip"
  }
}

# create nat gateway in public subnet az1
resource "aws_nat_gateway" "nat_gateway_az1"{
    allocation_id = aws_eip.eip_for_nat_gateway_az1.id
    subnet_id = var.subnet_az_a_id

    tags = {
        Name = "${terraform.workspace}_nat gateway az1"
    }

    depends_on = [var.internet_gateway]
}

# create nat gatway in public subnet az2
resource "aws_nat_gateway" "nat_gateway_az2"{
    allocation_id = aws_eip.eip_for_nat_gateway_az2.id
    subnet_id = var.subnet_az_b_id

    tags = {
        Name = "${terraform.workspace}_nat gateway az2"
    }

    depends_on = [var.internet_gateway]
}

# create private route table az1 and add route through nat gatway az1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.cidr_block_any
    nat_gateway_id = aws_nat_gateway.nat_gateway_az1.id
  }

  tags = {
    Name = "${terraform.workspace}_private route table az1"
  }
}

# associate private app subnet az1 with private route table az1
resource "aws_route_table_association" "private_app_subnet_az1_route" {
    subnet_id = var.subnet_az_a_id
    route_table_id = aws_route_table.private_route_table_az1.id
}

# create private route table az1 and add route through nat gatway az1
resource "aws_route_table" "private_route_table_az2" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.cidr_block_any
    nat_gateway_id = aws_nat_gateway.nat_gateway_az2.id
  }

  tags = {
    Name = "${terraform.workspace}_private route table az2"
  }
}

# associate private app subnet az1 with private route table az2
resource "aws_route_table_association" "private_app_subnet_az2_route" {
    subnet_id = var.subnet_az_b_id
    route_table_id = aws_route_table.private_route_table_az2.id
}