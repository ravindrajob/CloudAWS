################################################################
# Titre: Secret Orchestration (EKS CSI)
# Description : Injection sécurisée en RAM sans stocker dans etcd
# Auteur: Ravindra JOB | v2.0
# Update: 23/05/2026
################################################################

# Ce manifest simule l'intégration Kubernetes (SecretProviderClass)
# Il utilise l'identité OIDC du pod (IRSA) pour interroger AWS Secrets Manager
# et monter le secret dans un volume tmpfs (en mémoire).

resource "kubernetes_manifest" "secret_provider_class" {
  manifest = {
    "apiVersion" = "secrets-store.csi.x-k8s.io/v1"
    "kind"       = "SecretProviderClass"
    "metadata" = {
      "name"      = "aws-secrets-manager-provider"
      "namespace" = "application-tier"
    }
    "spec" = {
      "provider" = "aws"
      "parameters" = {
        "objects" = <<-EOT
          - objectName: "db-credentials-prod"
            objectType: "secretsmanager"
        EOT
      }
    }
  }
}
