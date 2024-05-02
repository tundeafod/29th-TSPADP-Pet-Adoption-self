resource "aws_instance" "sonarqube_server" {
  ami                         = var.ami
  instance_type               = "t2.medium"
  key_name                    = var.keypair
  vpc_security_group_ids      = [var.sonarqube-sg]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  user_data                   = local.sonarqube_user_data
  tags = {
    Name = var.name
  }
}



#Delete S3 Bucket & Dynamo DB table (Delete Dynamo DB table first)
# aws s3 rb s3://tfstate-tspadp --force
# aws dynamodb delete-table --table-name tspadp-backend --region eu-west-2

#CLI command that would create s3 bucket and Dynamo db
# aws s3api create-bucket --bucket tfstate-tspadp --region eu-west-2 --create-bucket-configuration LocationConstraint=your-region

# aws dynamodb create-table --table-name your table name --attribute-definitions AttributeName=LockID,AttributeType=S \
#     --key-schema AttributeName=LockID,KeyType=HASH \
#     --billing-mode PAY_PER_REQUEST \
#     --region your region