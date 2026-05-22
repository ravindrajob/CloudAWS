################################################################
# Titre: CloudAWS - README
# Description : Lab de simulation AWS Hardened (CAF & CNCF)
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ] Initial creation
################################################################

# CloudAWS - Lab de Simulation Amazon Web Services

💡 **Philosophie & Partage :** 
Ce dépôt constitue un laboratoire de démonstration pour les architectures **Amazon Web Services (AWS)**. Il reflète une approche standardisée et sécurisée de l'infrastructure "Cloud Native". 

Les configurations Terraform ici présentes sont des simulations conçues pour partager des bonnes pratiques sur le domaine **ravindra-job.com**. (OPSEC oblige, l'infrastructure réelle de production est totalement isolée).

## 🏗️ Architecture du Lab (Landing Zone CAF)

L'infrastructure est modulaire et suit une logique de séparation des responsabilités (**1 dossier = 1 composant**) :

1.  **`landingZone/Governance/`** : Verrouillage au niveau AWS Organizations via **SCPs** (Service Control Policies) et configuration de **IAM Identity Center**.
2.  **`landingZone/Connectivity/`** : Hub de transit moderne utilisant **AWS Transit Gateway** et **AWS Network Firewall**.
3.  **`landingZone/VPC-Spokes/`** : Réseaux applicatifs isolés avec accès PaaS sécurisé via **AWS PrivateLink** (Interface VPC Endpoints).
4.  **`landingZone/ALB-WAF/`** : Exposition HTTPS sécurisée via Application Load Balancer et **AWS WAF v2**.
5.  **`landingZone/EKS/`** : Déploiement d'un cluster Amazon EKS durci (Private Cluster) conforme aux standards CNCF.
6.  **`landingZone/AI-Agent-Security/`** : Architecture de sécurisation pour **Amazon Bedrock**, implémentant le concept **Action-to-Action (A2A)**.
7.  **`landingZone/Documentation/`** : Documentation industrielle exhaustive (Governance, Networking, Security).

## 🔒 Sécurité par Design
- **Zéro IP Publique** : Utilisation systématique de **Session Manager (SSM)** pour l'administration.
- **Identité Zéro Trust** : Bannissement des clés d'accès IAM au profit de **OIDC/Workload Identity Federation**.
- **Filtrage L7** : Inspection profonde via AWS Network Firewall.

---
*Dépôt maintenu selon une approche institutionnelle et souveraine.*
