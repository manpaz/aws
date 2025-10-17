output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1b.id,
    aws_subnet.public_2a.id,
    aws_subnet.public_2b.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1b.id,
    aws_subnet.private_2a.id,
    aws_subnet.private_2b.id,
    aws_subnet.private_3a.id,
    aws_subnet.private_3b.id
  ]
}

output "public_subnet_1a_id" {
  description = "ID of public subnet 1a"
  value       = aws_subnet.public_1a.id
}

output "public_subnet_1b_id" {
  description = "ID of public subnet 1b"
  value       = aws_subnet.public_1b.id
}

output "public_subnet_2a_id" {
  description = "ID of public subnet 2a"
  value       = aws_subnet.public_2a.id
}

output "public_subnet_2b_id" {
  description = "ID of public subnet 2b"
  value       = aws_subnet.public_2b.id
}

output "private_subnet_1a_id" {
  description = "ID of private subnet 1a"
  value       = aws_subnet.private_1a.id
}

output "private_subnet_1b_id" {
  description = "ID of private subnet 1b"
  value       = aws_subnet.private_1b.id
}

output "private_subnet_2a_id" {
  description = "ID of private subnet 2a"
  value       = aws_subnet.private_2a.id
}

output "private_subnet_2b_id" {
  description = "ID of private subnet 2b"
  value       = aws_subnet.private_2b.id
}

output "private_subnet_3a_id" {
  description = "ID of private subnet 3a"
  value       = aws_subnet.private_3a.id
}

output "private_subnet_3b_id" {
  description = "ID of private subnet 3b"
  value       = aws_subnet.private_3b.id
}

output "nat_gateway_a_id" {
  description = "ID of NAT Gateway A"
  value       = aws_nat_gateway.nat_a.id
}

output "nat_gateway_b_id" {
  description = "ID of NAT Gateway B"
  value       = aws_nat_gateway.nat_b.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_a_id" {
  description = "ID of private route table A"
  value       = aws_route_table.private_a.id
}

output "private_route_table_b_id" {
  description = "ID of private route table B"
  value       = aws_route_table.private_b.id
}

output "private_hosted_zone_id" {
  description = "ID of the private hosted zone"
  value       = aws_route53_zone.private.id
}

output "placement_group_id" {
  description = "ID of the placement group"
  value       = aws_placement_group.hpc.id
}
