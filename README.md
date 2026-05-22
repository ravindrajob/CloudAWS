################################################################
# Titre: CloudAWS - README
# Description : Lab de simulation Amazon Web Services Hardened
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v2.2 | RJ]
################################################################

# Amazon Web Services : Landing Zone Hardened

Ce dépôt centralise les briques d'infrastructure (IaC) nécessaires au déploiement d'une **Landing Zone** sécurisée sur AWS. L'architecture respecte les standards du **GCP/Azure CAF** (adaptés) et les principes de la **CNCF** pour garantir une posture Zéro Trust.

---

### 🧱 Architecture du Lab

L'infrastructure est découpée en services managés modulaires, facilitant l'évolution et l'audit.

| Module | Fonctionnalité | Hardening Spécifique |
| :--- | :--- | :--- |
| **`Governance`** | SCPs & IAM | Service Control Policies (No Public IP), Region Lock, WIF/OIDC. |
| **`Connectivity`** | Transit Hub | AWS Transit Gateway (TGW), Hub-and-Spoke. |
| **`Firewall`** | Perimeter Security | AWS Network Firewall, filtrage FQDN, inspection IPS. |
| **`Bastion`** | Zéro Trust Admin | Systems Manager (SSM) Session Manager, zéro port entrant. |
| **`Kubernetes`** | Orchestration | Amazon EKS Private Cluster, Control Plane Logging. |
| **`ReverseProxy`** | Web Exposition | Application Load Balancer (ALB), AWS WAF v2. |
| **`CDN`** | Edge Security | CloudFront, AWS Shield, intégration WAF. |
| **`AI-Security`** | AI Agent Proxy | Gateway A2A pour la sécurisation des flux Amazon Bedrock. |

---

### 🛡️ Principes de Sécurité (Security by Design)

- **Identité Fédérée :** Suppression des IAM Users avec Access Keys au profit du Workload Identity Federation pour la CI/CD.
- **Accès Privé :** Utilisation systématique d'AWS PrivateLink (Interface VPC Endpoints) pour la consommation des services AWS sans Internet.
- **Micro-segmentation :** Isolation stricte via Security Groups et ACLs réseau centralisées dans le Transit Gateway.

### ⚙️ Déploiement & Orchestration

L'orchestration est pilotée par un pipeline GitOps situé dans `.github/workflows/`. Le déploiement suit un ordonnancement par briques (Foundations, Network, Workloads) pour une traçabilité totale.

---
*Note : Ce dépôt est un environnement de simulation (Lab). Les configurations sont isolées et utilisent exclusivement le domaine `ravindra-job.com`.*
