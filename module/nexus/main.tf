resource "aws_instance" "nexus_server" {
  ami                         = var.ami_redhat
  instance_type               = "t2.xlarge"
  subnet_id                   = var.subnet_id
  key_name                    = var.keyname
  vpc_security_group_ids      = [var.nexus-sg]
  associate_public_ip_address = true
  user_data                   = local.nexus_user_data
  tags = {
    Name = var.name
  }
}