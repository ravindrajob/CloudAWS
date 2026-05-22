################################################################
# Titre: AWS Governance & Control Tower
# Description : Guide de la gouvernance et de la sécurité des identités
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 12/09/2025 [v1.0 | RJ] Initial baseline
################################################################

# Gouvernance AWS Hardened

Cette Landing Zone applique les standards du **AWS Cloud Adoption Framework (CAF)** pour garantir une infrastructure souveraine et sécurisée.

## 📋 Service Control Policies (SCPs)

Les SCPs agissent comme des garde-fous globaux au niveau de l'organisation AWS.

| Politique | État | Justification Technique |
| :--- | :--- | :--- |
| **Deny Public IP** | **Activé** | Interdit formellement l'attribution d'adresses IP publiques sur les instances EC2. |
| **Deny Internet Gateway** | **Activé** | Empêche la création de passerelles Internet dans les VPC applicatifs (Spokes). |
| **Region Lock** | **Activé** | Restreint le déploiement aux régions `eu-west-3` (Paris) et `eu-central-1` (Francfort). |

## 🛡️ Identity Zéro Trust (WIF Only)
Nous bannissons l'usage des **IAM Users** avec clés statiques (Access Key ID / Secret Access Key).
- **OIDC/Workload Identity** : Pour l'automatisation CI/CD (GitHub Actions).
- **IAM Identity Center (SSO)** : Pour l'accès humain, avec authentification multi-facteurs (MFA) obligatoire.

---
*Gouvernance méticuleuse conçue par Ravindra JOB.*
