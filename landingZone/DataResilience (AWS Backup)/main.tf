################################################################
# Titre: Data Resilience (AWS Backup WORM)
# Description : Sauvegardes immuables Anti-Ransomware
# Auteur: Ravindra JOB | v2.0
# Update: 23/05/2026
################################################################

resource "aws_backup_vault" "immutable_vault" {
  name        = "vault-immutable-lab"
  kms_key_arn = var.kms_key_arn
}

# Configuration Object Lock / WORM (Write Once Read Many)
# Empêche la suppression manuelle de la sauvegarde, même par un Root
resource "aws_backup_vault_lock_configuration" "worm" {
  backup_vault_name   = aws_backup_vault.immutable_vault.name
  changeable_for_days = 3    # Délai de grâce pour tester
  max_retention_days  = 365  # Durée de vie maximale
  min_retention_days  = 30   # Rétention inaltérable minimale
}

resource "aws_backup_plan" "nightly_backup" {
  name = "plan-nightly-resilience"

  rule {
    rule_name         = "DailyBackup"
    target_vault_name = aws_backup_vault.immutable_vault.name
    schedule          = "cron(0 22 * * ? *)"

    lifecycle {
      delete_after = 30 # S'aligne avec le min_retention_days du WORM
    }
  }
}
