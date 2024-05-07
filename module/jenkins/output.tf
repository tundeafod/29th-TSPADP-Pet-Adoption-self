output "jenkins_ip" {
  value = aws_instance.jenkins_server.public_ip
}
output "nexus_id" {
  value = aws_instance.jenkins_server.id
}