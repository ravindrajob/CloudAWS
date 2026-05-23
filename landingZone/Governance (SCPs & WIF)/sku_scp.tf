################################################################
# Titre: Governance - SKU Restrictions (FinOps)
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# SCP AWS: Interdiction formelle de lancer des instances coûteuses (ex: p4d, x1e)
resource "aws_organizations_policy" "deny_expensive_ec2" {
  name        = "DenyExpensiveSKUs"
  description = "Bloque l'usage de types d'instances AWS coûteuses"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "ec2:RunInstances"
        Resource = "arn:aws:ec2:*:*:instance/*"
        Condition = {
          "ForAnyValue:StringLike": {
            "ec2:InstanceType": [
              "p4d.*",
              "x1e.*",
              "u-*"
            ]
          }
        }
      }
    ]
  })
}
