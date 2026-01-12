output "public_subnet_id" {
  value = aws_subnet.private.id
}

output "public_sg_id" {
   value = aws_security_group.private.id
}
