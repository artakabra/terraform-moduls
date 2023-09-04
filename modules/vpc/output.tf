output "region"{
    value = var.region
}

output "project_name" {
    value = var.project_name
}

output "vpc_id" {
    value = aws_vpc.main.id
}

output "subnet_az_a_id" {
    value = aws_subnet.sub_az_a.id
}

output "subnet_az_b_id" {
    value = aws_subnet.sub_az_b.id
}

output "internet_gateway" {
    value = aws_internet_gateway.web_igw
}