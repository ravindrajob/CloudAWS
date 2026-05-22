################################################################
# Titre: Connectivity (Direct Connect) - README
# Description : Pourquoi privatiser la liaison hybride sur AWS
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ]
################################################################

# Connectivity (AWS Direct Connect)

💡 **Rôle du composant :** 
Établir un lien réseau physique et dédié entre les infrastructures locales et le réseau AWS.

## Pourquoi ce choix technique ?
**Direct Connect (DX)** est choisi pour s'affranchir de la volatilité de l'Internet public. Il garantit une performance constante pour les transferts massifs de données (sauvegardes, réplication de bases de données).

## Hardening spécifique (vs Standard)
- **Direct Connect Gateway :** Utilisation d'une passerelle centrale pour exposer le lien hybride à plusieurs VPCs via le **Transit Gateway (TGW)**, simplifiant le routage et renforçant la segmentation.
- **Link Encryption :** Possibilité de coupler DX avec un VPN IPsec (MACsec sur les connexions 10/100Gbps) pour assurer un chiffrement de niveau 2 sur le lien physique.
- **Redondance :** Configuration recommandée en mode "Haute Disponibilité" avec deux circuits distincts arrivant sur des routeurs AWS différents.

---
Adoption industrialisée du CAF avec surcouche de sécurité et intégration des pratiques CNCF.
