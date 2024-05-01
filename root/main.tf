# Include the keypair module for generating and managing SSH keys.
module "keypair" {
  source = "../module/keypair"
}

module "vpc" {
  source         = "../module/vpc"
  private-subnet = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  public-subnet  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  azs            = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

# module "securitygroup" {
#   source = "../module/securitygroup"
#   vpc-id = module.vpc.vpc_id
# }