################################################################
# Titre: AWS DataSecurity - KMS Customer Managed Keys
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# Utilisation systématique du chiffrement BYOK/CMK pour EBS, RDS et S3
resource "aws_kms_key" "lab_cmk" {
  description             = "KMS Key maitresse pour le chiffrement des donnees (Lab)"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  multi_region            = false

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "lab_cmk_alias" {
  name          = "alias/lab-encryption-key"
  target_key_id = aws_kms_key.lab_cmk.key_id
}
