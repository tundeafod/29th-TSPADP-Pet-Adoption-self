output "promgraf_ip" {
  value = aws_instance.promgraf-server.public_ip
}

output "prom_dns_name" {
  value = aws_elb.elb-promgraf.dns_name
}

output "prom_zone_id" {
  value = aws_elb.elb-promgraf.zone_id
}

output "graf_dns_name" {
  value = aws_elb.elb-promgraf.dns_name
}

output "graf_zone_id" {
  value = aws_elb.elb-promgraf.zone_id
}