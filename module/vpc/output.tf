output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pub_sub_1a_id" {
  value = aws_subnet.pub_sub_1a.id
}
output "pub_sub_1b_id" {
  value = aws_subnet.pub_sub_1b.id
}
output "pub_sub_1c_id" {
  value = aws_subnet.pub_sub_1c.id
}

output "pri_sub_1a_id" {
  value = aws_subnet.pri_sub_1a.id
}

output "pri_sub_1b_id" {
  value = aws_subnet.pri_sub_1b.id
}

output "pri_sub_1c_id" {
    value = aws_subnet.pri_sub_1c.id 
}

output "igw_id" {
    value = aws_internet_gateway.internet_gateway
}