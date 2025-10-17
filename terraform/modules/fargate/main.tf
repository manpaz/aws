# Fargate Module

# ECS Fargate Cluster
resource "aws_ecs_cluster" "fargate" {
  name = "${var.organization}-${var.environment}-fargate-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-fargate-cluster"
  })
}

# Fargate Task Execution Role
resource "aws_iam_role" "fargate_task_execution_role" {
  name = "${var.organization}-${var.environment}-fargate-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "fargate_task_execution_role_policy" {
  role       = aws_iam_role.fargate_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Fargate Task Role
resource "aws_iam_role" "fargate_task_role" {
  name = "${var.organization}-${var.environment}-fargate-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.default_tags
}

# Fargate Task Definition
resource "aws_ecs_task_definition" "fargate" {
  family                   = "${var.organization}-${var.environment}-fargate-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.fargate_task_execution_role.arn
  task_role_arn           = aws_iam_role.fargate_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "${var.organization}-fargate-container"
      image = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.service_name}:latest"
      
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]

      environment = var.environment_variables

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-create-group"  = "true"
          "awslogs-group"       = "/bashlinux/fargate/${var.service_name}"
          "awslogs-region"      = var.aws_region
          "awslogs-stream-prefix" = "task"
        }
      }

      essential = true
    }
  ])

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-fargate-task-definition"
  })
}

# Fargate Service
resource "aws_ecs_service" "fargate" {
  name            = "${var.organization}-${var.environment}-fargate-service"
  cluster         = aws_ecs_cluster.fargate.id
  task_definition = aws_ecs_task_definition.fargate.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.organization}-fargate-container"
    container_port   = 8080
  }

  deployment_configuration {
    maximum_percent         = 200
    minimum_healthy_percent = 50
  }

  health_check_grace_period_seconds = 60

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-fargate-service"
  })
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "fargate" {
  name              = "/bashlinux/fargate/${var.service_name}"
  retention_in_days = 14

  tags = var.default_tags
}
