# ECS Module

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.organization}-${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-ecs-cluster"
  })
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.organization}-${var.environment}-ecs-task-execution-role"

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

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.organization}-${var.environment}-ecs-task-role"

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

# ECS Task Definition
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.organization}-${var.environment}-${var.service_name}"
  network_mode             = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn           = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "${var.organization}-${var.service_name}"
      image = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.service_name}:latest"
      
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]

      environment = var.environment_variables

      environmentFiles = var.environment_file_arn != "" ? [
        {
          type  = "s3"
          value = var.environment_file_arn
        }
      ] : []

      healthCheck = {
        command     = ["CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1"]
        interval    = 5
        timeout     = 3
        retries     = 2
        startPeriod = 60
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-create-group"  = "true"
          "awslogs-group"         = "/bashlinux/ecs/task-${var.service_name}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "task"
        }
      }

      essential = true
    }
  ])

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-${var.service_name}-task-definition"
  })
}

# ECS Service
resource "aws_ecs_service" "main" {
  name            = "${var.organization}-${var.environment}-${var.service_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.organization}-${var.service_name}"
    container_port   = 8080
  }

  service_registries {
    registry_arn = aws_service_discovery_service.main.arn
    port        = 8080
  }

  deployment_configuration {
    maximum_percent         = 200
    minimum_healthy_percent = 50
  }

  health_check_grace_period_seconds = 60

  depends_on = [aws_lb_listener_rule.main]

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-${var.service_name}-service"
  })
}

# Service Discovery Namespace
resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "${var.organization}-${var.environment}.local"
  description = "Private DNS namespace for ${var.organization} ${var.environment}"
  vpc         = var.vpc_id

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-private-dns-namespace"
  })
}

# Service Discovery Service
resource "aws_service_discovery_service" "main" {
  name = var.service_name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 60
      type = "A"
    }

    dns_records {
      ttl  = 60
      type = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_grace_period_seconds = 30

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-${var.service_name}-discovery-service"
  })
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "main" {
  name              = "/bashlinux/ecs/task-${var.service_name}"
  retention_in_days = 14

  tags = var.default_tags
}

# ALB Listener Rule (if ALB is provided)
resource "aws_lb_listener_rule" "main" {
  count        = var.target_group_arn != "" ? 1 : 0
  listener_arn = var.listener_arn
  priority     = var.listener_priority

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  condition {
    path_pattern {
      values = ["/${var.service_name}/*"]
    }
  }
}
