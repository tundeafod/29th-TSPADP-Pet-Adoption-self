output "nexus_ip" {
  value = aws_instance.nexus_server.public_ip
}

output "nexus_id" {
  value = aws_instance.nexus_server.id
}