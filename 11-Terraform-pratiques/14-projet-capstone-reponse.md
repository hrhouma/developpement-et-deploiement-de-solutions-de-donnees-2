---
title: "Pratique 14 - Projet Capstone - Réponse"
description: "Éléments de réponse pour le Projet Capstone"
emoji: "🏠"
slug: "14-projet-capstone"
sidebar_position: 14
---

# Projet Capstone - Éléments de réponse

### Serveur Web Hautement Disponible avec Sauvegardes Automatisées

:::info Description du Projet
Création d'une infrastructure web hautement disponible et sécurisée avec les caractéristiques suivantes :

- Instance EC2 hébergeant un site web PHP
- Base de données RDS MySQL 
- Bucket S3 pour la synchronisation des logs et pages web
- Auto-scaling (1-3 instances) avec load balancer
- Notifications SNS pour les événements d'auto-scaling
- Snapshots automatiques du système
- Gestion du cycle de vie des logs
:::

### Spécifications Techniques

:::tip Infrastructure Web
- Instance EC2 avec serveur web PHP
- Base de données RDS MySQL
- Load balancer pour la distribution du trafic
- Auto-scaling group (min: 1, max: 3 instances)
:::

:::tip Stockage et Sauvegardes
- Bucket S3 avec dossiers séparés pour :
  - Logs système
  - Pages web
  - Logs HTTPS
- Synchronisation automatique toutes les 5 minutes
- Snapshots EBS toutes les 12 heures (conservation des 2 derniers)
:::

:::tip Gestion des Logs
- Cycle de vie des logs :
  - Suppression/archivage vers Glacier après 2 jours
  - Versioning activé pour les logs
:::

:::tip Monitoring et Notifications
- Configuration SNS pour notifications par email :
  - Scale-out des instances
  - Scale-in des instances
  - Alertes de performance
:::

### Points Importants à Considérer

:::warning Sécurité
- Configuration HTTPS
- Groupes de sécurité appropriés
- Accès restreint à la base de données
:::

:::warning Haute Disponibilité
- Multi-AZ pour RDS
- Load balancing entre instances
- Auto-scaling basé sur la charge
:::

:::warning Performance
- Optimisation des instances EC2
- Configuration appropriée de RDS
- Gestion efficace du stockage S3
:::

### Livrables Attendus

:::danger Livrables Requis
1. Configuration Terraform complète
2. Documentation des choix d'architecture
3. Procédures de déploiement et de test
4. Plan de sauvegarde et de restauration
:::


:::info Avant de commencer
Il est fortement recommandé de réaliser les deux **Pratiques 11 - Création d'une instance EC2** et **Pratique 12 - Travail pratique 2** avant d'entreprendre ce projet Capstone.

La Pratique 11 vous permettra de :
- Maîtriser les concepts de base de Terraform
- Comprendre le workflow de déploiement
- Vous familiariser avec la syntaxe et les ressources AWS
- Acquérir les fondamentaux nécessaires pour ce projet plus complexe

➜ [Accéder à la Pratique 11](./11-creation-instance-ec2.md)

La Pratique 12 vous permettra de :
- Maîtriser les concepts de base de Terraform
- Comprendre le workflow de déploiement
- Vous familiariser avec la syntaxe et les ressources AWS
- Acquérir les fondamentaux nécessaires pour ce projet plus complexe

➜ [Accéder à la Pratique 12](./12-travail-pratique-02.md)
:::

:::tip Prérequis
Assurez-vous d'avoir :
- Complété avec succès la Pratique 11
- Une bonne compréhension des services AWS utilisés
- Un compte AWS avec les permissions nécessaires
- Terraform correctement installé et configuré
:::
