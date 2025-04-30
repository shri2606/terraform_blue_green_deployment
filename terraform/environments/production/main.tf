module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = "prod"
}

module "load_balancer" {
  source = "../../modules/load_balancer"

  environment          = "prod"
  security_group_ids   = [module.vpc.public_security_group_id]
  subnet_ids           = module.vpc.public_subnet_ids
  vpc_id               = module.vpc.vpc_id
  active_target_group  = var.active_target_group
}

module "blue_environment" {
  source = "../blue"

  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.private_subnet_ids
  security_group_ids   = [module.vpc.private_security_group_id]
  target_group_arn     = module.load_balancer.blue_target_group_arn
  environment          = "blue"
}

module "green_environment" {
  source = "../green"

  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.private_subnet_ids
  security_group_ids   = [module.vpc.private_security_group_id]
  target_group_arn     = module.load_balancer.green_target_group_arn
  environment          = "green"
} 