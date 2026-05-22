################################################################
# Titre: AWS Systems Manager (SSM) - Zéro Trust Administration
# Description : Configuration de l'accès sans bastion (No Public IP)
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 25/11/2025 [v1.0 | RJ]
################################################################

# 1. IAM Role pour l'accès SSM (CAF: Operational Excellence)
resource "aws_iam_role" "ssm_instance_role" {
  name = "lab-aws-ssm-instance-role"

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
}

# Attachement de la politique managée AmazonSSMManagedInstanceCore
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "lab-aws-ssm-instance-profile"
  role = aws_iam_role.ssm_instance_role.name
}

# 2. VPC Endpoints pour SSM (PrivateLink)
# CNCF Compliance: Accès administratif sans passer par Internet
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.ssm_endpoint_sg_id]
}
