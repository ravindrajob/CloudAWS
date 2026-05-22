################################################################
# Titre: AWS Governance & OIDC (WIF)
# Description : Imposition des SCPs et Workload Identity Federation
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 12/09/2025 [v1.0 | RJ] Initial governance setup
################################################################

# 1. Service Control Policy (SCP) - Deny Public IP (CAF Security)
resource "aws_organizations_policy" "deny_public_ip" {
  name        = "DenyPublicIP"
  description = "Interdire l'attribution d'adresses IP publiques (Zéro Trust)"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "ec2:AssociateAddress"
        Resource = "*"
      },
      {
        Effect   = "Deny"
        Action   = "ec2:RunInstances"
        Resource = "*"
        Condition = {
          "Bool" : { "ec2:AssociatePublicIpAddress" : "true" }
        }
      }
    ]
  })
}

# 2. OIDC Provider pour GitHub Actions (WIF)
# Élimine l'usage des IAM Access Keys statiques
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Role IAM fédéré
resource "aws_iam_role" "github_actions_role" {
  name = "id-github-actions-lab"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:ravindrajob/CloudAWS:*"
          }
        }
      }
    ]
  })
}
