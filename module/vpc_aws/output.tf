output "vpc_id" {
  value = aws_vpc.main.id
}

output "cidr_block_public" {
  value = aws_subnet.public[*].id
}

output "cidr_private" {
  value = aws_subnet.private[*].id
}

output "cidr_database" {
  value = aws_subnet.database[*].id
}