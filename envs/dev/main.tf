provider "aws" {
  profile = "terraform"
  region  = var.aws_region
}

module "network" {
  source = "../../modules/network"
  
}

module "iam" {
  source = "../../modules/iam/"

}

module "app" {
  source          = "../../modules/db/"
  
  subnet_id       = module.network.public_subnet_id
  sg_id           = module.network.public_sg_id
  iam_ssm_profile = module.iam.ssm_profile
}
