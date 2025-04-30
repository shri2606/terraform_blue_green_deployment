output "endpoint" {
  description = "Connection endpoint for the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "db_name" {
  description = "Name of the database"
  value       = aws_db_instance.this.db_name
}

output "db_username" {
  description = "Master username for the database"
  value       = aws_db_instance.this.username
}

output "db_port" {
  description = "Port of the database"
  value       = aws_db_instance.this.port
}

output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.this.id
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.this.name
}

output "db_parameter_group_name" {
  description = "Name of the DB parameter group"
  value       = aws_db_parameter_group.this.name
}

# output "db_password" {
#   description = "Generated password for the database"
#   value       = random_password.db_password.result
#   sensitive   = true
# }