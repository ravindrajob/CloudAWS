################################################################
# Titre: AWS AI-Agent Security Gateway (A2A)
# Description : Proxy de sécurité pour Amazon Bedrock (Filtre sémantique)
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 20/11/2025 [v1.0 | RJ] Initial AI Gateway for Bedrock
################################################################

# 1. Lambda Proxy (A2A Gateway)
# Ce service intercepte les requêtes vers Bedrock pour valider les actions.
resource "aws_lambda_function" "ai_security_proxy" {
  filename      = "ai_proxy_payload.zip"
  function_name = "lab-aws-ai-security-gateway"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  environment {
    variables = {
      SECURITY_LEVEL = "hardened"
      DOMAIN         = "ravindra-job.com"
    }
  }

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

# 2. IAM Policy : Accès restrictif à Bedrock
resource "aws_iam_policy" "bedrock_restricted_access" {
  name        = "BedrockRestrictedAccess"
  description = "Autoriser uniquement l'invocation de modèles spécifiques"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "bedrock:InvokeModel"
        Effect   = "Allow"
        Resource = "arn:aws:bedrock:${var.region}::foundation-model/anthropic.claude-v3-sonnet-*"
      }
    ]
  })
}

# 3. VPC Endpoint pour Bedrock (PrivateLink)
# CNCF Compliance: Zéro trafic sur Internet public
resource "aws_vpc_endpoint" "bedrock" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.bedrock-runtime"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
}
