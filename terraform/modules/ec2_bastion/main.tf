# EC2 Bastion Module

# Data source for latest AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-24.04-lts-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Key Pair
resource "aws_key_pair" "bastion" {
  key_name   = "${var.organization}-${var.environment}-bastion-key"
  public_key = var.public_key

  tags = var.default_tags
}

# IAM Role for Bastion
resource "aws_iam_role" "bastion" {
  name = "${var.organization}-${var.environment}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.default_tags
}

# IAM Policy for Bastion
resource "aws_iam_policy" "bastion" {
  name        = "${var.organization}-${var.environment}-bastion-policy"
  description = "Policy for bastion host"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeTags",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumes",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "bastion" {
  role       = aws_iam_role.bastion.name
  policy_arn = aws_iam_policy.bastion.arn
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.organization}-${var.environment}-bastion-profile"
  role = aws_iam_role.bastion.name

  tags = var.default_tags
}

# Security Group for Bastion
resource "aws_security_group" "bastion" {
  name_prefix = "${var.organization}-${var.environment}-bastion"
  vpc_id      = var.vpc_id
  description = "Security group for bastion host"

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

# EC2 Instance
resource "aws_instance" "bastion" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name              = aws_key_pair.bastion.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id             = var.subnet_id
  iam_instance_profile  = aws_iam_instance_profile.bastion.name

  root_block_device {
    volume_type = "gp3"
    volume_size = var.ebs_volume_size
    encrypted   = true
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    organization = var.organization
    environment  = var.environment
    domain       = var.domain
  }))

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-bastion"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP for Bastion
resource "aws_eip" "bastion" {
  domain = "vpc"
  instance = aws_instance.bastion.id

  tags = merge(var.default_tags, {
    Name = "${var.organization}-${var.environment}-bastion-eip"
  })
}

# Route53 Record for Bastion
resource "aws_route53_record" "bastion" {
  zone_id = var.hosted_zone_id
  name    = "bastion.${var.domain}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.bastion.public_ip]
}
