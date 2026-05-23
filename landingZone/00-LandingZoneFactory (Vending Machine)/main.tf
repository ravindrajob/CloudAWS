################################################################
# Titre: Landing Zone Factory (Vending Machine)
# Description : Usine de création de comptes AWS industrialisée
# Auteur: Ravindra JOB | v2.0
# Update: 23/05/2026
################################################################

# Déploiement d'un nouveau compte AWS via AWS Organizations
resource "aws_organizations_account" "new_landing_zone" {
  name      = "lz-${var.environment}-${var.business_unit}"
  email     = "aws-lz-${var.environment}-${var.business_unit}@ravindra-job.com"
  parent_id = var.ou_parent_id

  role_name = "OrganizationAccountAccessRole"

  # Tags pour la facturation (FinOps)
  tags = {
    Environment  = var.environment
    BusinessUnit = var.business_unit
    CostCenter   = var.cost_center
  }
}

# Dès la création, on attache automatiquement une SCP restrictive
resource "aws_organizations_policy_attachment" "baseline_scp" {
  policy_id = var.baseline_scp_id
  target_id = aws_organizations_account.new_landing_zone.id
}
