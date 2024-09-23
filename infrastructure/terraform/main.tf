# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Use the random provider for generating passwords
provider "random" {}

# Data source for available AWS availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + var.public_subnet_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Create a public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create a security group for the application
resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Security group for the ${var.project_name} app"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a DB subnet group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.project_name} DB Subnet Group"
  }
}

# Generate a random password for the database
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create an RDS Aurora cluster
resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${var.project_name}-db-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "13.7"
  availability_zones      = data.aws_availability_zones.available.names
  database_name           = "vcinvestmentdb"
  master_username         = "dbadmin"
  master_password         = random_password.db_password.result
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.app.id]

  tags = {
    Name = "${var.project_name} DB Cluster"
  }
}

# Create RDS Aurora instances
resource "aws_rds_cluster_instance" "main" {
  count               = var.db_instance_count
  identifier          = "${var.project_name}-db-instance-${count.index}"
  cluster_identifier  = aws_rds_cluster.main.id
  instance_class      = var.db_instance_class
  engine              = aws_rds_cluster.main.engine
  engine_version      = aws_rds_cluster.main.engine_version
}

# Create an ElastiCache subnet group
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-cache-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

# Create an ElastiCache Redis cluster
resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${var.project_name}-cache"
  engine               = "redis"
  node_type            = var.cache_node_type
  num_cache_nodes      = var.cache_node_count
  parameter_group_name = "default.redis6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.app.id]
}

# Create an ECS cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  tags = {
    Name = "${var.project_name} ECS Cluster"
  }
}

# Create an ECR repository
resource "aws_ecr_repository" "app" {
  name                 = "${var.project_name}-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}