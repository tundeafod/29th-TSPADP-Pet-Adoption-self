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


#CLI command that would create s3 bucket and Dynamo db
# aws s3api create-bucket --bucket your-terraform-state-bucket-name --region your-region --create-bucket-configuration LocationConstraint=your-region

# aws dynamodb create-table --table-name your-terraform-state-lock-table --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST
