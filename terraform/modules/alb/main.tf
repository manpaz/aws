# ALB Module

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.organization}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false
  enable_http2                = true
  ip_address_type            = "dualstack"

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-public-alb"
  })
}

# Target Group for ECS
resource "aws_lb_target_group" "ecs" {
  name        = "${var.organization}-${var.environment}-ecs-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-ecs-tg"
  })
}

# Target Group for EKS
resource "aws_lb_target_group" "eks" {
  name        = "${var.organization}-${var.environment}-eks-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-eks-tg"
  })
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }
}

# Listener Rule for ECS Service
resource "aws_lb_listener_rule" "ecs" {
  listener_arn = aws_lb_listener.https.arn
  priority    = var.listener_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

# Listener Rule for EKS Service
resource "aws_lb_listener_rule" "eks" {
  listener_arn = aws_lb_listener.https.arn
  priority    = var.listener_priority + 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks.arn
  }

  condition {
    path_pattern {
      values = ["/web/*"]
    }
  }
}
