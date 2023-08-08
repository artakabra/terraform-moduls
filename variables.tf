variable "project_name" {}

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_az_a_cidr" {
  default     = "10.0.10.0/24"
  description = "Subnet in AZ a"
  type        = string
}

variable "subnet_az_b_cidr" {
  default     = "10.0.11.0/24"
  description = "Subnet in AZ b"
  type        = string
}

variable "my_public_ip" {
  type        = string
  description = "My public IP address"
  default     = "0.0.0.0/0"
}

variable "azs" {
  description = "AZs in the Region"
  type        = list(string)
  default = [
    "eu-central-1a",
    "eu-central-1b",
    "eu-central-1c",
  ]
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "amis" {
  type = map(string)
  default = {
    "eu-central-1" = "ami-04e601abe3e1a910f"
  }
}

variable "ingress_ports" {
  description = "List of Ingress Ports"
  type        = list(number)
  default     = [80, 3000]
}

variable "asg_max_size" {}

variable "asg_min_size" {}

variable "asg_desired_capacity" {}

variable "instance_type" {
  default     = "t2.micro"
  description = "Free Tier"
  type        = string
}

variable "cidr_block_any" {
  default     = "0.0.0.0/0"
  description = "Any"
  type        = string
}