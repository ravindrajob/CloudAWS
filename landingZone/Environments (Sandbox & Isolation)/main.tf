################################################################
# Titre: Environments (Sandbox & Isolation)
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# Création d'un compte AWS totalement isolé sous la racine de l'organisation
# Pas de connexion TGW vers la production.

resource "aws_organizations_account" "sandbox" {
  name  = "aws-sandbox-isolated-lab"
  email = "aws-sandbox@ravindra-job.com"

  # On peut attacher ici des SCPs très restrictives
}

# Alerte spécifique à la Sandbox (Destruction si dépassement)
resource "aws_budgets_budget" "sandbox_budget" {
  name              = "budget-sandbox-strict"
  budget_type       = "COST"
  limit_amount      = "50"
  limit_unit        = "USD"
  time_period_start = "2026-01-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["admin@ravindra-job.com"]
  }
}
