################################################################
# Titre: SecOps (Security Hub & GuardDuty)
# Description : SOC Cloud natif pour le Datacenter AWS
# Auteur: Ravindra JOB | v1.3
# Update: 22/05/2026
################################################################

# 1. Activation de GuardDuty (Threat Detection)
resource "aws_guardduty_detector" "main" {
  enable = true
}

# 2. Activation de Security Hub (Compliance & Findings)
resource "aws_securityhub_account" "main" {}

# 3. Standards de conformité (CNCF Compliance)
resource "aws_securityhub_standards_subscription" "cis_aws" {
  depends_on    = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.region}::standards/aws-foundational-security-best-practices/v/1.0.0"
}

# 4. Export vers un S3 de sécurité pour audit long-terme
resource "aws_s3_bucket" "security_findings" {
  bucket        = "lab-aws-security-audit-${var.random_suffix}"
  force_destroy = true
}
