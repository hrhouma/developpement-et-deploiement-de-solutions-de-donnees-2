---
title: "Pratique 15 - Exercices individuels à la maison"
description: "Exercices pratiques à réaliser individuellement pour maîtriser Terraform"
emoji: "🏠"
slug: "15-exercices-individuels"
sidebar_position: 15
---

# Exercices individuels à la maison

## Exercice 1 
:::info
**Création d'une instance EC2 basique**
:::

Créez une instance EC2 avec les spécifications suivantes :
- Type d'instance : t2.micro
- AMI : Ubuntu Server 20.04 LTS
- Region : us-east-1
- Un groupe de sécurité autorisant SSH (port 22)


## Exercice 2 
:::info
**Création d'un bucket S3**
:::

Créez un bucket S3 avec les spécifications suivantes :
- Un nom unique pour le bucket
- La région us-east-1
- Le versioning activé
- Des tags appropriés pour l'identification

# Exercice 3 
:::info
**Création d'un bucket S3 avec un bucket de stockage de logs**
:::

Créez une configuration Terraform qui :

- Crée un bucket S3 principal pour stocker des données
- Crée un second bucket S3 dédié au stockage des logs d'accès du premier bucket
- Configure le logging du bucket principal vers le bucket de logs
- Active le versioning sur le bucket principal
- Ajoute des tags appropriés sur les deux buckets

Les spécifications techniques :
- Région : us-east-1
- Noms des buckets : à votre choix (mais uniques)
- Tags minimum requis : 
  - Environment = "Dev"
  - Project = "Terraform-Training"

Points importants à considérer :
- La politique d'accès appropriée doit être configurée pour permettre l'écriture des logs
- Les noms des buckets doivent être uniques globalement
- Le bucket de logs doit avoir les permissions appropriées pour recevoir les logs

# Exercice 4 : 
:::info
**Création d'un bucket S3 avec un bucket de stockage de logs et un bucket de stockage de snapshots**
:::

Créez une configuration Terraform qui :

- Crée un bucket S3 principal pour stocker des données
- Crée un second bucket S3 pour les logs d'accès
- Crée un troisième bucket S3 pour les snapshots
- Configure le logging du bucket principal vers le bucket de logs
- Active le versioning sur le bucket principal
- Configure la réplication des snapshots vers le bucket de snapshots
- Ajoute des tags appropriés sur tous les buckets

Les spécifications techniques :
- Région : us-east-1
- Noms des buckets : à votre choix (mais uniques)
- Tags minimum requis :
  - Environment = "Dev" 
  - Project = "Terraform-Training"

Points importants à considérer :
- Les politiques d'accès appropriées doivent être configurées pour permettre :
  - L'écriture des logs
  - La réplication des snapshots
- Les noms des buckets doivent être uniques globalement
- Le bucket de logs doit avoir les permissions appropriées
- Le bucket de snapshots doit être configuré avec une politique de cycle de vie


# Exercice 5

:::info
**Création d'un bucket S3 avec un bucket de stockage de logs et un bucket de stockage de snapshots et un bucket de stockage de snapshots**
:::

Créez une configuration Terraform qui :

- Crée un bucket S3 principal pour stocker des données
- Crée un second bucket S3 pour les logs d'accès 
- Crée un troisième bucket S3 pour les snapshots
- Crée un quatrième bucket S3 pour les sauvegardes
- Configure le logging du bucket principal vers le bucket de logs
- Active le versioning sur le bucket principal
- Configure la réplication des snapshots vers le bucket de snapshots
- Configure la réplication des sauvegardes vers le bucket de sauvegardes
- Ajoute des tags appropriés sur tous les buckets

Les spécifications techniques :
- Région : us-east-1
- Noms des buckets : à votre choix (mais uniques)
- Tags minimum requis :
  - Environment = "Dev"
  - Project = "Terraform-Training"

Points importants à considérer :
- Les politiques d'accès appropriées doivent être configurées pour permettre :
  - L'écriture des logs
  - La réplication des snapshots
  - La réplication des sauvegardes
- Les noms des buckets doivent être uniques globalement
- Le bucket de logs doit avoir les permissions appropriées
- Le bucket de snapshots doit être configuré avec une politique de cycle de vie
- Le bucket de sauvegardes doit être configuré avec une politique de cycle de vie


## Exercice 6 
:::info
**Déploiement multi-ressources**
:::

Déployez une infrastructure comprenant :
- Une instance EC2 avec :
  - Un groupe de sécurité permettant l'accès SSH
  - Une AMI Ubuntu
  - Un type d'instance t2.micro
  - Des tags appropriés
- Un bucket S3 avec :
  - Un nom unique globalement
  - Le versioning activé
  - Des tags appropriés
- Configuration de l'accès :
  - Créez un rôle IAM pour l'instance EC2
  - Attachez une politique permettant l'accès au bucket S3
  - Associez le rôle à l'instance EC2
Points importants à considérer :
- Utilisez des noms uniques pour éviter les conflits
- Configurez les permissions minimales requises
- Testez l'accès depuis l'instance vers le bucket
- Documentez votre configuration avec des commentaires

## Exercice 7
:::info
**Utilisation des variables**
:::

Reprenez l'exercice 1 en :
- Externalisant toutes les valeurs dans des variables
- Créant un fichier terraform.tfvars
- Ajoutant des descriptions pour chaque variable

## Exercice 8 
:::info
**Modules Terraform**
:::

Créez un module réutilisable pour :
- Déployer une instance EC2
- Configurer son groupe de sécurité
- Gérer les tags

## Exercice 9 
:::info
**Projet final**
:::

Combinez tous les exercices précédents pour créer :
- Une architecture complète avec EC2, S3, et sécurité
- Utilisez des modules
- Implémentez les bonnes pratiques vues en cours

:::tip Conseils
- Testez chaque configuration avant de passer à l'exercice suivant
- Utilisez `terraform fmt` pour formater votre code
- Documentez votre code avec des commentaires
- N'oubliez pas de détruire vos ressources après les tests
:::
