locals {
  name = "Jenkins-Ansible-Auto-discovery1"
}

data "aws_secretsmanager_secret_version" "afodsecret" {
  secret_id = "afodsecret"
}

# data "aws_secretsmanager_secret" "autodiscovery" {
#   name = "admin"
#   depends_on = [
#     aws_secretsmanager_secret.autodiscovery
#   ]
# }

# data "aws_secretsmanager_secret_version" "version_secret" {
#   secret_id = data.aws_secretsmanager_secret.autodiscovery.id
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
module "jenkins" {
  source     = "../module/jenkins"
  ami-redhat = "ami-035cecbff25e0d91e"
  subnet-id  = module.vpc.privatesub1
  jenkins-sg = module.securitygroup.jenkins_sg
  key-name   = module.keypair.public-key-id
  name       = "${local.name}-jenkins"
  nr-key     = ""
  nr-acc-id  = ""
  nr-region  = ""
  nexus-ip   = ""
}
module "ansible" {
  source      = "../module/ansible"
  ami-redhat  = "ami-035cecbff25e0d91e"
  subnet-id   = module.vpc.publicsub2
  ansible-sg  = module.securitygroup.ansible_sg
  key-name    = module.keypair.public-key-id
  name        = "${local.name}-ansible"
  nr-key      = ""
  nr-acc-id   = ""
  nr-region   = ""
  nexus-ip    = ""
  private_key = module.keypair.private-key-id
}

module "database" {
  source                  = "../module/database"
  db_subnet_grp           = "db-subnetgroup"
  subnet                  = [module.vpc.privatesub1, module.vpc.privatesub2, module.vpc.privatesub3]
  security_group_mysql_sg = module.securitygroup.rds-sg
  db_name                 = "petclinic"
  db_username             = "admin"
  db_password             = data.aws_secretsmanager_secret_version.afodsecret.secret_string
  name                    = "${local.name}-db-subnet"
}

module "prod-asg" {
  source          = "../module/prod-asg"
  ami-prd         = "ami-035cecbff25e0d91e"
  keyname         = module.keypair.public-key-id
  asg-sg          = module.securitygroup.asg-sg
  nexus-ip-prd    = module.nexus.nexus_pub_ip
  nr-key-prd      = "4246321"
  nr-acc-id-prd   = "NRAK-12DI66KMZCHKYRSAB9D7NA7111W"
  nr-region-prd   = "EU"
  vpc-zone-id-prd = [module.vpc.privatesub1, module.vpc.privatesub2]
  asg-prd-name    = "${local.name}-prod-asg"
  tg-arn          = module.prod-lb.prod-tg-arn
}