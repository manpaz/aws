# Security Groups Module

# Common Security Group
resource "aws_security_group" "common" {
  name_prefix = "${var.organization}-${var.environment}-common"
  vpc_id      = var.vpc_id
  description = "Common security group for ${var.organization} ${var.environment}"

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-common-sg"
  })
}

# Bastion Security Group
resource "aws_security_group" "bastion" {
  name_prefix = "${var.organization}-${var.environment}-bastion"
  vpc_id      = var.vpc_id
  description = "Bastion security group for ${var.organization} ${var.environment}"

  ingress {
    description = "SSH from deployer"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.deployer_ip}/32"]
  }

  ingress {
    description = "OpenVPN from deployer"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["${var.deployer_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-bastion-sg"
  })
}

# ALB Security Group
resource "aws_security_group" "alb" {
  name_prefix = "${var.organization}-${var.environment}-alb"
  vpc_id      = var.vpc_id
  description = "ALB security group for ${var.organization} ${var.environment}"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
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

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-alb-sg"
  })
}

# ECS Security Group
resource "aws_security_group" "ecs" {
  name_prefix = "${var.organization}-${var.environment}-ecs"
  vpc_id      = var.vpc_id
  description = "ECS security group for ${var.organization} ${var.environment}"

  ingress {
    description     = "HTTP from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "HTTPS from ALB"
    from_port       = 8443
    to_port         = 8443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-ecs-sg"
  })
}

# EKS Master Security Group
resource "aws_security_group" "eks_master" {
  name_prefix = "${var.organization}-${var.environment}-eks-master"
  vpc_id      = var.vpc_id
  description = "EKS master security group for ${var.organization} ${var.environment}"

  ingress {
    description     = "HTTPS from EKS workers"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_worker.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-eks-master-sg"
  })
}

# EKS Worker Security Group
resource "aws_security_group" "eks_worker" {
  name_prefix = "${var.organization}-${var.environment}-eks-worker"
  vpc_id      = var.vpc_id
  description = "EKS worker security group for ${var.organization} ${var.environment}"

  ingress {
    description = "All traffic from VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description     = "HTTPS to EKS master"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_master.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-eks-worker-sg"
  })
}

# RDS Security Group
resource "aws_security_group" "rds" {
  name_prefix = "${var.organization}-${var.environment}-rds"
  vpc_id      = var.vpc_id
  description = "RDS security group for ${var.organization} ${var.environment}"

  ingress {
    description     = "MySQL from ECS"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  ingress {
    description     = "PostgreSQL from ECS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-rds-sg"
  })
}

# DocumentDB Security Group
resource "aws_security_group" "documentdb" {
  name_prefix = "${var.organization}-${var.environment}-documentdb"
  vpc_id      = var.vpc_id
  description = "DocumentDB security group for ${var.organization} ${var.environment}"

  ingress {
    description     = "DocumentDB from ECS"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-documentdb-sg"
  })
}

# ElastiCache Security Group
resource "aws_security_group" "elasticache" {
  name_prefix = "${var.organization}-${var.environment}-elasticache"
  vpc_id      = var.vpc_id
  description = "ElastiCache security group for ${var.organization} ${var.environment}"

  ingress {
    description     = "Redis from ECS"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-elasticache-sg"
  })
}

# RabbitMQ Security Group
resource "aws_security_group" "rabbitmq" {
  name_prefix = "${var.organization}-${var.environment}-rabbitmq"
  vpc_id      = var.vpc_id
  description = "RabbitMQ security group for ${var.organization} ${var.environment}"

  ingress {
    description     = "RabbitMQ from ECS"
    from_port       = 5672
    to_port         = 5672
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  ingress {
    description     = "RabbitMQ Management from ECS"
    from_port       = 15672
    to_port         = 15672
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-rabbitmq-sg"
  })
}
