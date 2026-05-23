################################################################
# Titre: AWS Bastion - SSM Endpoints (No Public IP)
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# Pour respecter le Zéro Trust, l'accès SSH se fait via AWS Systems Manager (SSM)
# Les VPC Endpoints garantissent que l'agent SSM communique en IP privée.

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.ssm_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.ssm_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.ssm_sg.id]
  private_dns_enabled = true
}

resource "aws_security_group" "ssm_sg" {
  name        = "sg-ssm-endpoints-lab"
  vpc_id      = var.vpc_id
  description = "Autorise le trafic HTTPS depuis le VPC vers SSM"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}
