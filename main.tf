
provider "aws" {
  region = "us-east-1" 
}


module "vpc" {
  source = "./modules/vpc"
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.igw_id
}

module "nat" {
  source    = "./modules/nat"
  subnet_id = module.subnets.public_subnets[0]
}

module "routing" {
  source            = "./modules/routing"
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.vpc.igw_id
  nat_gateway_id    = module.nat.nat_gateway_id
  public_subnets    = module.subnets.public_subnets
  private_subnets   = module.subnets.private_subnets
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "compute" {
  source          = "./modules/compute"
  subnet_id       = module.subnets.public_subnets[0]
  sg_id           = module.security.jump_sg_id
  private_subnets = module.subnets.private_subnets
}

module "loadbalancer" {
  source     = "./modules/loadbalancer"
  subnet_ids = module.subnets.public_subnets
  sg_id      = module.security.jump_sg_id
}

output "jump_server_ip" {
  value = module.compute.jump_server_ip
}

output "load_balancer_dns" {
  value = module.loadbalancer.lb_dns_name
}
