################################################################
# Titre: Governance (SCPs & WIF) - README
# Description : Pourquoi et comment nous verrouillons AWS Organizations
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.1 | RJ]
################################################################

# Gouvernance (AWS Organizations & WIF)

💡 **Rôle du composant :** 
Ce module constitue la racine de confiance de la Landing Zone. Il permet d'imposer des règles de conformité immuables sur l'ensemble des comptes de l'organisation.

## Pourquoi ce choix technique ?
Contrairement à une gestion par compte isolé, l'utilisation des **Service Control Policies (SCPs)** permet de garantir qu'aucun administrateur local ne peut déroger aux règles de sécurité de l'entreprise (ex: créer une IP publique).

## Hardening spécifique (vs Standard)
- **Workload Identity Federation (WIF)** : Nous avons banni les clés d'accès statiques (`IAM Access Keys`). Nous utilisons l'OIDC pour que GitHub Actions s'authentifie via des jetons éphémères. Cela élimine le risque de vol de secrets.
- **SCPs Paranoïaques** : 
    - Blocage de la création d'Internet Gateway dans les Spokes.
    - Blocage du déploiement en dehors des régions souveraines (`eu-west-3`).
    - Interdiction de désactiver les logs d'audit CloudTrail.

---
*Standard industriel AWS validé par Ravindra JOB.*
