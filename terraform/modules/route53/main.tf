# Route53 Module

# Public Hosted Zone
resource "aws_route53_zone" "public" {
  count = var.create_public_zone ? 1 : 0
  name  = var.domain_name

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-public-zone"
    "bashlinux:network-visibility" = "public"
  })
}

# Private Hosted Zone
resource "aws_route53_zone" "private" {
  count = var.create_private_zone ? 1 : 0
  name  = var.domain_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-private-zone"
    "bashlinux:network-visibility" = "private"
  })
}

# DNS Records
resource "aws_route53_record" "records" {
  for_each = var.dns_records
  zone_id  = var.create_public_zone ? aws_route53_zone.public[0].zone_id : aws_route53_zone.private[0].zone_id
  name     = each.value.name
  type     = each.value.type
  ttl      = each.value.ttl
  records  = each.value.records

  dynamic "alias" {
    for_each = each.value.alias != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}

# Health Checks
resource "aws_route53_health_check" "main" {
  for_each = var.health_checks

  fqdn                            = each.value.fqdn
  port                            = each.value.port
  type                            = each.value.type
  resource_path                   = each.value.resource_path
  failure_threshold               = each.value.failure_threshold
  request_interval                = each.value.request_interval
  cloudwatch_alarm_name           = each.value.cloudwatch_alarm_name
  cloudwatch_alarm_region         = each.value.cloudwatch_alarm_region
  insufficient_data_health_status = each.value.insufficient_data_health_status

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-health-check-${each.key}"
  })
}

# Route53 Resolver Rules
resource "aws_route53_resolver_rule" "main" {
  for_each = var.resolver_rules

  domain_name          = each.value.domain_name
  name                 = each.value.name
  rule_type            = each.value.rule_type
  resolver_endpoint_id = each.value.resolver_endpoint_id

  dynamic "target_ip" {
    for_each = each.value.target_ips
    content {
      ip   = target_ip.value.ip
      port = target_ip.value.port
    }
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-resolver-rule-${each.key}"
  })
}

# Route53 Resolver Rule Associations
resource "aws_route53_resolver_rule_association" "main" {
  for_each = var.resolver_rule_associations

  resolver_rule_id = each.value.resolver_rule_id
  vpc_id          = each.value.vpc_id
}

# ACM Certificate
resource "aws_acm_certificate" "main" {
  count = var.create_certificate ? 1 : 0

  domain_name               = var.certificate_domain
  subject_alternative_names = var.certificate_san_domains
  validation_method         = var.certificate_validation_method

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-certificate"
  })
}

# ACM Certificate Validation
resource "aws_route53_record" "certificate_validation" {
  for_each = var.create_certificate && var.certificate_validation_method == "DNS" ? {
    for dvo in aws_acm_certificate.main[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.create_public_zone ? aws_route53_zone.public[0].zone_id : aws_route53_zone.private[0].zone_id
}

resource "aws_acm_certificate_validation" "main" {
  count = var.create_certificate && var.certificate_validation_method == "DNS" ? 1 : 0

  certificate_arn         = aws_acm_certificate.main[0].arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}
