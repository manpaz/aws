output "public_zone_id" {
  description = "ID of the public hosted zone"
  value       = var.create_public_zone ? aws_route53_zone.public[0].zone_id : null
}

output "public_zone_name_servers" {
  description = "Name servers of the public hosted zone"
  value       = var.create_public_zone ? aws_route53_zone.public[0].name_servers : null
}

output "private_zone_id" {
  description = "ID of the private hosted zone"
  value       = var.create_private_zone ? aws_route53_zone.private[0].zone_id : null
}

output "private_zone_name_servers" {
  description = "Name servers of the private hosted zone"
  value       = var.create_private_zone ? aws_route53_zone.private[0].name_servers : null
}

output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = var.create_certificate ? aws_acm_certificate.main[0].arn : null
}

output "certificate_validation_status" {
  description = "Validation status of the ACM certificate"
  value       = var.create_certificate ? aws_acm_certificate.main[0].status : null
}

output "health_check_ids" {
  description = "IDs of the health checks"
  value       = { for k, v in aws_route53_health_check.main : k => v.id }
}

output "resolver_rule_ids" {
  description = "IDs of the resolver rules"
  value       = { for k, v in aws_route53_resolver_rule.main : k => v.id }
}
