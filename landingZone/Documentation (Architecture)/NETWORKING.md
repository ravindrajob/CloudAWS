################################################################
# Titre: AWS Architecture Réseau (Transit Gateway & TGW)
# Description : Guide de la topologie Hub & Spoke via TGW
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 15/09/2025 [v1.0 | RJ] Initial topology design
################################################################

# Architecture Réseau : AWS Transit Gateway

L'infrastructure réseau repose sur le service **AWS Transit Gateway (TGW)**, agissant comme un hub de connectivité régional pour interconnecter plusieurs VPCs et environnements hybrides.

## 🏗️ Topologie Hub & Spoke
- **Transit Gateway** : Point central de routage. Il permet de centraliser l'inspection et de simplifier le maillage.
- **VPC Hub** : Contient les services partagés, les passerelles NAT centrales et le pare-feu périmétrique.
- **VPC Spokes** : Réseaux applicatifs isolés. Ils n'ont pas d'Internet Gateway propre (Zéro Internet Direct).

## 🛡️ Administration Sécurisée : AWS Session Manager
Conformément à la vision **Zéro Trust**, nous bannissons l'usage des bastions traditionnels exposés.
- **Accès sans Bastion** : L'administration des instances EC2 et des nœuds EKS se fait via **Systems Manager (SSM) Session Manager**.
- **Zéro Port Ouvert** : Aucun port entrant (22/3389) n'est ouvert sur les Security Groups. La connexion est établie via un tunnel HTTPS sécurisé et authentifié par IAM.

## 🌐 Filtrage Périmétrique (Egress Control)
Toute sortie vers Internet est inspectée par l'**AWS Network Firewall** situé dans le VPC Hub. 
- **Filtrage FQDN** : Autorisation uniquement des domaines Whitelistés (ex: `*.ravindra-job.com`, `github.com`).
- **Inspection IPS** : Détection et blocage des signatures de malwares connus.

---
Adoption industrialisée du CAF avec surcouche de sécurité et intégration des pratiques CNCF.
