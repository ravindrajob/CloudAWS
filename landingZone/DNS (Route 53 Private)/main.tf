################################################################
# Titre: DNS (Route 53 Private)
# Description : Maillage Zéro Trust et entrées de simulation Lab
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.2 | RJ]
################################################################

# 1. Zone DNS Privée (CAF: Hybrid Connectivity DNS)
resource "aws_route53_zone" "private_zone" {
  name = "ravindra-job.com"

  # Liaison physique au VPC (VPC Link)
  # Indispensable pour la résolution sémantique interne
  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}

# 2. Enregistrements DNS de démonstration (Simulation Lab)

resource "aws_route53_record" "api_endpoint" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "api.ravindra-job.com"
  type    = "A"
  ttl     = "300"
  records = ["10.100.0.100"] # IP fictive de l'ALB interne
}

resource "aws_route53_record" "eks_internal" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "k8s-master.ravindra-job.com"
  type    = "A"
  ttl     = "300"
  records = ["10.1.1.254"] # IP fictive Endpoint EKS
}

resource "aws_route53_record" "bedrock_privatelink" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "bedrock-ai.ravindra-job.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["vpce-0123456789abcdef.bedrock-runtime.eu-west-3.vpce.amazonaws.com"] # Redirection PrivateLink
}
