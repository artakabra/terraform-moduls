provider "aws" {
  region  = var.aws_region
  profile = "intern"
}

# Create VPC
module "vpc" {
  source         = "./modules/vpc"
  region         = var.aws_region
  project_name   = var.project_name
  vpc_cidr       = var.vpc_cidr_block
  cidr_block_any = var.cidr_block_any
  subnet_az_a_cidr    = var.subnet_az_a_cidr
  subnet_az_b_cidr    = var.subnet_az_b_cidr
}

module "security_group" {
  source       = "./modules/security-groups"
  vpc_id       = module.vpc.vpc_id
  my_public_ip = var.my_public_ip
}

module "alb" {
  source                = "./modules/alb"
  project_name          = module.vpc.project_name
  alb_security_group_id = module.security_group.alb_security_group_id
  subnet_az_a           = 
  subnet_az_b           = 
  vpc_id                = module.vpc.vpc_id
}