provider "aws" {
  region  = "eu-west-2"
  profile = "team1"
}

resource "aws_s3_bucket" "s3b-team" {
  bucket        = "tfstate-tspadp"
  force_destroy = true
  tags = {
    Name = "tfstate-tspadp"
  }
}

resource "aws_dynamodb_table" "db-state-team" {
  name           = "tspadp-backend"
  hash_key       = "LockID"
  read_capacity  = "10"
  write_capacity = "10"
  attribute {
    name = "LockID"
    type = "S"
  }
}