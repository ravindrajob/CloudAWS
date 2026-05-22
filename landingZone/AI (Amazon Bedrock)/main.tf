################################################################
# Titre: AI (Amazon Bedrock)
# Description : Modèles d'IA managés avec isolation PrivateLink
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.1 | RJ]
################################################################

# 1. Activation des modèles Bedrock (Simulation via IAM)
# Bedrock ne nécessite pas d'instance, mais des permissions d'invocation.
resource "aws_iam_policy" "bedrock_access" {
  name        = "BedrockModelInvocation"
  description = "Autoriser l'invocation des modèles Claude 3.5 et Titan"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "bedrock:InvokeModel"
        Effect   = "Allow"
        Resource = "arn:aws:bedrock:${var.region}::foundation-model/*"
      }
    ]
  })
}

# 2. Sécurité Réseau : Interface VPC Endpoint (PrivateLink)
# CNCF Compliance : Zéro trafic via l'Internet public pour les données IA
resource "aws_vpc_endpoint" "bedrock_runtime" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.bedrock-runtime"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.bedrock_sg_id]
}

# 3. Exposition via Application Load Balancer (ALB)
# On configure un Target Group vers l'IP interne du VPC Endpoint
# Le trafic est inspecté par AWS WAF v2 avant d'atteindre Bedrock
