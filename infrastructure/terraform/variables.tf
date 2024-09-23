# AWS Region
variable "aws_region" {
  description = "The AWS region to deploy the infrastructure"
  type        = string
  default     = "us-west-2"
}

# Project Name
variable "project_name" {
  description = "The name of the project, used for tagging and naming resources"
  type        = string
  default     = "vc-investment-discovery"
}

# Environment
variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

# VPC CIDR
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnet Count
variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 2
}

# Private Subnet Count
variable "private_subnet_count" {
  description = "Number of private subnets to create"
  type        = number
  default     = 2
}

# RDS Instance Class
variable "db_instance_class" {
  description = "The instance class for RDS database instances"
  type        = string
  default     = "db.r5.large"
}

# RDS Instance Count
variable "db_instance_count" {
  description = "Number of RDS instances in the Aurora cluster"
  type        = number
  default     = 2
}

# ElastiCache Node Type
variable "cache_node_type" {
  description = "The node type for ElastiCache Redis cluster"
  type        = string
  default     = "cache.t3.micro"
}

# ElastiCache Node Count
variable "cache_node_count" {
  description = "Number of nodes in the ElastiCache Redis cluster"
  type        = number
  default     = 1
}

# ECS Task CPU
variable "ecs_task_cpu" {
  description = "The amount of CPU to allocate for each ECS task"
  type        = number
  default     = 256
}

# ECS Task Memory
variable "ecs_task_memory" {
  description = "The amount of memory to allocate for each ECS task"
  type        = number
  default     = 512
}