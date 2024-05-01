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