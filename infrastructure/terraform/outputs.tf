# Output definitions for the Venture Capital Investment Discovery app infrastructure

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "db_endpoint" {
  description = "The endpoint of the RDS Aurora cluster"
  value       = aws_rds_cluster.main.endpoint
}

output "db_reader_endpoint" {
  description = "The reader endpoint of the RDS Aurora cluster"
  value       = aws_rds_cluster.main.reader_endpoint
}

output "cache_endpoint" {
  description = "The endpoint of the ElastiCache Redis cluster"
  value       = aws_elasticache_cluster.main.cache_nodes[0].address
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.app.repository_url
}

output "app_security_group_id" {
  description = "The ID of the main application security group"
  value       = aws_security_group.app.id
}