---
title: "Pratique 13 - Projet Capstone - Énoncé"
description: "Déployer une infrastructure AWS complète et hautement disponible avec Terraform"
emoji: "🏠"
slug: "13-projet-capstone"
sidebar_position: 13
---

# Projet Capstone : Infrastructure Web Hautement Disponible avec Sauvegardes Automatisées

Ce projet vise à concevoir et déployer une infrastructure cloud complète sur AWS en utilisant **Terraform**. L'objectif est de construire une solution hautement disponible, sécurisée et évolutive, intégrant des sauvegardes automatiques et une gestion efficace des ressources.

## Table des matières
- [Introduction](#introduction)
- [Spécifications Techniques](#spécifications-techniques)
- [Structure des Fichiers](#structure-des-fichiers)
- [Étapes de Déploiement](#etapes-de-deploiement)
- [Nettoyage de l'Infrastructure](#nettoyage-de-l-infrastructure)
- [Livrables](#livrables)
- [Prérequis](#prerequis)

---

<a name="introduction"></a>

## Introduction

Ce projet vous permettra de mettre en pratique vos compétences sur **Terraform** et AWS. Vous déploierez une infrastructure comprenant les éléments suivants :
- **Serveur web PHP** hébergé sur EC2 avec gestion du trafic par un Load Balancer.
- **Base de données RDS MySQL** pour une gestion efficace des données.
- **Auto-scaling** pour gérer les charges dynamiques (1 à 3 instances).
- **Buckets S3** pour stocker les logs et synchroniser les fichiers.
- **Sauvegardes automatiques (snapshots EBS)** et gestion du cycle de vie des logs.
- **Notifications SNS** pour surveiller et gérer l'infrastructure.

---

<a name="specifications-techniques"></a>

## Spécifications Techniques

### 1. **Infrastructure Web**
- **Instances EC2** : Serveur web PHP (Apache ou Nginx).
- **Base de données RDS** : MySQL avec déploiement Multi-AZ.
- **Load Balancer** : Distribution du trafic entre les instances EC2.
- **Auto-scaling** : Minimum 1 instance, maximum 3 instances selon la charge.

### 2. **Stockage et Sauvegardes**
- **Buckets S3** :
  - Stockage des logs système, HTTPS, et pages web dans des dossiers séparés.
  - **Synchronisation automatique** toutes les 5 minutes.
- **Snapshots EBS** :
  - Snapshots automatiques des volumes toutes les 12 heures.
  - Conservation des **2 derniers snapshots** uniquement.

### 3. **Gestion des Logs**
- **Cycle de vie des logs** :
  - Suppression ou archivage dans **Amazon Glacier** après 2 jours.
  - Versioning activé pour les logs.

### 4. **Monitoring et Notifications**
- **Notifications SNS** pour :
  - Augmentation ou réduction des instances.
  - Alertes sur les performances.
  - Événements critiques.

### 5. **Sécurité et Haute Disponibilité**
- HTTPS pour les connexions au serveur web.
- **Groupes de sécurité** : Accès restreint aux ressources.
- **RDS Multi-AZ** pour garantir la haute disponibilité.

---

<a name="structure-des-fichiers"></a>

## Structure des Fichiers

Voici l'arborescence complète du projet :

```plaintext
TERRAFORM-1/
├── .terraform/                 # Fichiers de backend Terraform
├── lambda_package/             # Scripts Python pour les fonctions Lambda
│   ├── lambda_function.py
│   ├── log.py
│   ├── webpage.py
├── .terraform.lock.hcl         # Fichier de verrouillage pour les dépendances Terraform
├── autoscaling.tf              # Configuration de l'auto-scaling group
├── Instructions.md             # Guide de déploiement
├── lambda_function.zip         # Archive pour déployer la fonction Lambda
├── log_sync_function.zip       # Fonction Lambda pour synchroniser les logs
├── main.tf                     # Configuration principale Terraform
├── newtest.pem                 # Clé privée pour accès SSH (exemple)
├── rds.tf                      # Configuration de la base RDS
├── s3.tf                       # Buckets S3 pour logs et fichiers
├── snapshot.tf                 # Configuration des snapshots EBS
├── terraform.tfstate           # État actuel de l'infrastructure
├── terraform.tfstate.backup    # Backup de l'état précédent
└── webpage_sync_function.zip   # Fonction Lambda pour synchroniser les pages web
```

---

<a name="etapes-de-deploiement"></a>

## Étapes de Déploiement

### 1. **Initialisation du Projet**
- Clonez le dépôt Git :
  ```bash
  git clone https://github.com/hrhouma/terraform-1.git
  cd terraform-1
  ```

- Installez les dépendances et initialisez Terraform :
  ```bash
  terraform init
  ```

### 2. **Configuration des Variables**
- Remplacez les valeurs des variables dans les fichiers appropriés :
  - `ami`, `key_name`, `subnet_ids`, `vpc_id` dans `autoscaling.tf` et `main.tf`.
  - Identifiants de la base RDS (`username`, `password`) dans `rds.tf`.
  - Noms des buckets dans `s3.tf`.
  - Volume ID dans `lambda_function.py`.

### 3. **Validation de la Configuration**
- Vérifiez votre configuration :
  ```bash
  terraform validate
  ```

### 4. **Planification**
- Simulez les changements à appliquer :
  ```bash
  terraform plan
  ```

### 5. **Déploiement**
- Appliquez la configuration pour déployer l'infrastructure :
  ```bash
  terraform apply --auto-approve
  ```

### 6. **Tests**
- Accédez à l'application via l'URL du Load Balancer.
- Vérifiez les logs dans les buckets S3.
- Confirmez la création des snapshots EBS.

---

<a name="nettoyage-de-l-infrastructure"></a>

## Nettoyage de l'Infrastructure

Lorsque vous avez terminé, détruisez l'infrastructure pour éviter les frais inutiles :
```bash
terraform destroy --auto-approve
```

---

<a name="livrables"></a>

## Livrables

Les éléments suivants doivent être soumis à la fin du projet :

1. **Code Terraform complet** : Incluez tous les fichiers `.tf` et scripts nécessaires.
2. **Documentation** :
   - Architecture et choix techniques.
   - Procédure de déploiement et de test.
3. **Capture d'écran** : 
   - De l'application déployée.
   - Des buckets S3 avec les logs.
   - Des snapshots EBS dans AWS.
4. **Plan de sauvegarde et restauration** :
   - Incluez les étapes pour restaurer les snapshots et les fichiers S3.

---

<a name="prerequis"></a>

## Prérequis

### Outils et Compétences
- **Terraform** : Installé et configuré.
- **AWS CLI** : Configuré avec un utilisateur IAM ayant les permissions nécessaires.
- **Compte AWS actif** : Incluant des services actifs (EC2, RDS, S3, etc.).

### Connaissances Requises
Avant de commencer, il est recommandé d'avoir complété :
- **Pratique 11** : Création d'une instance EC2.
- **Pratique 12** : Déploiement d'une infrastructure Terraform de base.

➜ [Accéder à la Pratique 11](./11-creation-instance-ec2.md)  
➜ [Accéder à la Pratique 12](./12-travail-pratique-02.md)

---

## Résumé

Ce projet Capstone est une opportunité de mettre en pratique vos compétences Terraform dans un environnement réel. Vous apprendrez à gérer des ressources AWS complexes, à automatiser les sauvegardes, et à optimiser la disponibilité et la sécurité de vos applications. 

**Bonne chance ! 🚀 💪**
