output "Sonarqube-ip" {
  value = module.sonarqube.sonarqube_ip
}

output "bastion-ip" {
  value = module.bastion.bastion_ip
}

output "nexus-ip" {
  value = module.nexus.nexus_ip
}