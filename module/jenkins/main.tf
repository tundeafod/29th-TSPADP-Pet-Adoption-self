resource "aws_instance" "jenkins_server" {
  ami                         = var.ami-redhat
  instance_type               = "t2.medium"
  subnet_id                   = var.subnet-id
  vpc_security_group_ids      = [var.jenkins-sg]
  associate_public_ip_address = true
  key_name                    = var.key-name
  user_data                   = local.jenkins_user_data

  tags = {
    Name = var.name
  }
}