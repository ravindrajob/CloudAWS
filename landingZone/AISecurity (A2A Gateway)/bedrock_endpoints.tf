################################################################
# Titre: AWS AISecurity - A2A Gateway & Bedrock Endpoints
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# 1. VPC Endpoint pour Amazon Bedrock (Zéro Trust AI)
# Assure que les flux vers les LLM (Claude, Titan) ne traversent jamais Internet
resource "aws_vpc_endpoint" "bedrock_runtime" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.bedrock-runtime"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.ai_endpoint_sg.id]
  private_dns_enabled = true
}

resource "aws_security_group" "ai_endpoint_sg" {
  name        = "sg-bedrock-endpoint-lab"
  description = "Controle d'acces strict vers l'API Bedrock"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }
}
