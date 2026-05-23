################################################################
# Titre: Supply Chain Security (ECR)
# Description : Registre isolé, images immuables, scan vulnérabilités
# Auteur: Ravindra JOB | v2.0
# Update: 23/05/2026
################################################################

resource "aws_ecr_repository" "secure_registry" {
  name                 = "lab-secure-registry"
  image_tag_mutability = "IMMUTABLE" # Empêche d'écraser un tag validé (Anti-Tampering)

  # Scan à chaque Push via Amazon Inspector / Clair
  image_scanning_configuration {
    scan_on_push = true
  }

  # Chiffrement systématique par clé gérée par le client (CMEK)
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }
}

# Politique de rétention des images (FinOps & SecOps)
resource "aws_ecr_lifecycle_policy" "cleanup" {
  repository = aws_ecr_repository.secure_registry.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1,
      description  = "Keep last 30 images",
      selection    = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 30 },
      action       = { type = "expire" }
    }]
  })
}
