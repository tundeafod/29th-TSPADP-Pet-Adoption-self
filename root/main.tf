resource "aws_s3_bucket" "s3b-team2" {
  bucket        = "tfstate-tspadp"
  force_destroy = true
  tags = {
    Name = "tfstate-tspadp"
  }
}

resource "aws_dynamodb_table" "db-state-team2" {
  name           = "tspadp-backend"
  hash_key       = "LockID"
  read_capacity  = "10"
  write_capacity = "10"
  attribute {
    name = "LockID"
    type = "S"
  }
}

module "vpc" {
    source = "./modules/vpc"
    region = var.region
    project_name = var.project_name
    vpc_cidr         = var.vpc_cidr
    pub_sub_1a_cidr = var.pub_sub_1a_cidr
    pub_sub_2b_cidr = var.pub_sub_1b_cidr
    pri_sub_3a_cidr = var.pri_sub_1c_cidr
    pri_sub_4b_cidr = var.pri_sub_1a_cidr
    pri_sub_5a_cidr = var.pri_sub_1b_cidr
    pri_sub_6b_cidr = var.pri_sub_1c_cidr
}

module "keypair" {
  source = "./module/keypair"
}

module "securitygroup" {
  source = "./module/securitygroup"
  vpc-id = module.vpc.vpc_id
}
