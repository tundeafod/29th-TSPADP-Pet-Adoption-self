locals {
  name = "Jenkins-Ansible-Auto-discovery"
}

# data "aws_secretsmanager_secret" "secretmanager" {
#   name = "rds_admin"
#   # depends_on = [
#   #   aws_secretsmanager_secret.secretmanager
#   # ]
# }

# data "aws_secretsmanager_secret_version" "secret" {
#   secret_id = data.aws_secretsmanager_secret.secretmanager.id
# }

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

module "securitygroup" {
  source = "../module/securitygroup"
  vpc_id = module.vpc.vpc_id
}

module "sonarqube" {
  source       = "../module/sonarqube"
  ami          = "ami-053a617c6207ecc7b"
  sonarqube-sg = module.securitygroup.sonarqube_sg
  subnet_id    = module.vpc.publicsub1
  keypair      = module.keypair.public-key-id
  name         = "${local.name}-sonarqube"
  nr-key       = ""
  nr-acc-id    = ""
  nr-region    = ""
}

module "bastion" {
  source      = "../module/bastion"
  ami_redhat  = "ami-035cecbff25e0d91e"
  subnet_id   = module.vpc.publicsub2
  bastion-sg  = module.securitygroup.bastion_sg
  keyname     = module.keypair.public-key-id
  private_key = module.keypair.private-key-id
  name        = "${local.name}-bastion"
}

module "nexus" {
  source     = "../module/nexus"
  ami_redhat = "ami-035cecbff25e0d91e"
  subnet_id  = module.vpc.publicsub3
  nexus-sg   = module.securitygroup.nexus_sg
  keyname    = module.keypair.public-key-id
  name       = "${local.name}-nexus"
  nr-key     = ""
  nr-acc-id  = ""
  nr-region  = ""
}

module "nexus" {
  source     = "../module/jenkins"
  ami-redhat = "ami-035cecbff25e0d91e"
  subnet-id  = module.vpc.privatesub1
  jenkins-sg = module.securitygroup.jenkins_sg
  key-name   = module.keypair.public-key-id
  name       = "${local.name}-nexus"
  nr-key     = ""
  nr-acc-id  = ""
  nr-region  = ""
}