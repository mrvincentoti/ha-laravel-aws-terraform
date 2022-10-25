/*output "efs_dns_name" {
  description = "The DNS name of EFS"
  value       = aws_efs_mount_target.laravel-mount-targets[0].dns_name
}*/

output "db_name" {
  description = "The name of RDS database"
  value       = aws_rds_cluster.laravel-rds-cluster.database_name
}

output "db_hostname" {
  description = "The DNS name of RDS"
  value       = aws_rds_cluster.laravel-rds-cluster.endpoint
}

output "db_username" {
  description = "Database username"
  value       = aws_rds_cluster.laravel-rds-cluster.master_username
}

output "db_password" {
  description = "Database password"
  value       = aws_rds_cluster.laravel-rds-cluster.master_password
}

output "clients_sg" {
  description = "The security group ids of data layer clients"
  value = [
    aws_security_group.laravel-db-client-sg.id 
    #aws_security_group.laravel-cache-client-sg.id,
    #aws_security_group.laravel-fs-client-sg.id
    ]
}