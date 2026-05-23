################################################################
# Titre: FinOps (Cost & Usage Report)
# Description : Configuration des rapports de coûts détaillés vers S3
# Auteur: Ravindra JOB | v1.3
# Update: 22/05/2026
################################################################

# 1. Bucket S3 pour les rapports FinOps (CAF: Financial Management)
resource "aws_s3_bucket" "billing_bucket" {
  bucket        = "lab-aws-billing-reports-${var.random_suffix}"
  force_destroy = true
}

# 2. Cost & Usage Report (CUR)
resource "aws_cur_report_definition" "billing_report" {
  report_name                = "lab-aws-cost-usage-report"
  time_unit                  = "HOURLY"
  format                     = "textORcsv"
  compression                = "GZIP"
  additional_artifacts       = ["REDSHIFT", "QUICKSIGHT"]
  s3_bucket                  = aws_s3_bucket.billing_bucket.id
  s3_prefix                  = "cur"
  s3_region                  = var.region
  report_versioning          = "CREATE_NEW_REPORT"
}

# 3. Budget AWS
resource "aws_budgets_budget" "monthly_budget" {
  name              = "lab-aws-monthly-budget"
  budget_type       = "COST"
  limit_amount      = "150"
  limit_unit        = "USD"
  time_period_start = "2026-01-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["admin@ravindra-job.com"]
  }
}
