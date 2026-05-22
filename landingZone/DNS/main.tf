################################################################
# Titre: AWS Route 53 Private DNS
# Description : Gestion des zones DNS privées pour ravindra-job.com
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 15/10/2025 [v1.0 | RJ]
################################################################

resource "aws_route53_zone" "private" {
  name = "ravindra-job.com"

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}

# Exemple d'enregistrement pour le Lab
resource "aws_route53_record" "n8n" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "n8n.ravindra-job.com"
  type    = "A"
  ttl     = "300"
  records = [var.n8n_private_ip]
}
