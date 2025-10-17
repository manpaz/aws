output "instance_id" {
  description = "ID of the bastion instance"
  value       = aws_instance.bastion.id
}

output "instance_arn" {
  description = "ARN of the bastion instance"
  value       = aws_instance.bastion.arn
}

output "public_ip" {
  description = "Public IP of the bastion instance"
  value       = aws_eip.bastion.public_ip
}

output "private_ip" {
  description = "Private IP of the bastion instance"
  value       = aws_instance.bastion.private_ip
}

output "security_group_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion.id
}

output "key_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.bastion.key_name
}

output "dns_name" {
  description = "DNS name of the bastion host"
  value       = "bastion.${var.domain}"
}
