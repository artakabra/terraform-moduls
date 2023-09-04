provider "aws" {
  region = var.aws_region
}

# Create VPC
module "vpc" {
  source           = "./modules/vpc"
  region           = var.aws_region
  project_name     = var.project_name
  vpc_cidr         = var.vpc_cidr_block
  subnet_az_a_cidr = var.subnet_az_a_cidr
  subnet_az_b_cidr = var.subnet_az_b_cidr
  azs              = var.azs
}

# Create nat gatway
module "nat_gateway" {
  source           = "./modules/nat-gateway"
  subnet_az_a_id   = module.vpc.subnet_az_a_id
  internet_gateway = module.vpc.internet_gateway
  subnet_az_b_id   = module.vpc.subnet_az_b_id
  vpc_id           = module.vpc.vpc_id
  cidr_block_any   = var.cidr_block_any
}

# Create security group
module "security_group" {
  source       = "./modules/security-groups"
  vpc_id       = module.vpc.vpc_id
  my_public_ip = var.my_public_ip
}

# Create Application load balancer
module "alb" {
  source                = "./modules/alb"
  project_name          = module.vpc.project_name
  alb_security_group_id = module.security_group.alb_security_group_id
  subnet_az_a_id        = module.vpc.subnet_az_a_id
  subnet_az_b_id        = module.vpc.subnet_az_b_id
  vpc_id                = module.vpc.vpc_id
}

# Create auto scaling group
module "asg" {
  source                     = "./modules/asg"
  project_name               = module.vpc.project_name
  aws_region                 = var.aws_region
  instance_type              = var.instance_type
  asg_min_size               = var.asg_min_size
  asg_desired_capacity       = var.asg_desired_capacity
  asg_max_size               = var.asg_max_size
  amis                       = var.amis
  subnet_az_a_id             = module.vpc.subnet_az_a_id
  subnet_az_b_id             = module.vpc.subnet_az_b_id
  alb_target_group_arn       = module.alb.alb_target_group_arn
  inctance_security_group_id = module.security_group.inctance_security_group_id
}