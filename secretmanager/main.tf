locals {
  name = "Jenkins-Ansible-Auto-discovery"
}

resource "aws_kms_key" "rds_kms_key" {
  description             = "KMS key for RDS"
  is_enabled              = true
  enable_key_rotation     = true
  deletion_window_in_days = 7
  tags = {
    Name = "${local.name}-kms_key"
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "secretmanager" {
  kms_key_id              = aws_kms_key.rds_kms_key.id
  name                    = "rds_admin"
  description             = "RDS Admin password"
  recovery_window_in_days = 14

  tags = {
    Name = "${local.name}-secretmanager"
  }
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secretmanager.id
  secret_string = random_password.password.result
}