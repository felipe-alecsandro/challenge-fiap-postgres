output "host" {
  value = aws_db_instance.db_postgres.address
}

output "identifier" {
  value = aws_db_instance.db_postgres.identifier
}

output "name" {
  value = aws_db_instance.db_postgres.name
}

output "port" {
  value = aws_db_instance.db_postgres.port
}

output "username" {
  value = aws_db_instance.db_postgres.username
}