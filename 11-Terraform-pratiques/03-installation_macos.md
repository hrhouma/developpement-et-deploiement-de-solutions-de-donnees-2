---
title: "Pratique 03 - Installation de Terraform sur macOS"
description: "Découvrez comment installer Terraform sur macOS."
emoji: "🚀"
slug: "03-installation_macos"
sidebar_position: 3
---

# Installation de Terraform sur macOS

L'installation de Terraform sur macOS est un processus simple, particulièrement si vous utilisez Homebrew, un gestionnaire de paquets populaire pour macOS. Voici comment installer Terraform sur un système macOS.

## Installation avec Homebrew

1. **Installation de Homebrew** (si vous ne l'avez pas déjà installé) :

   Ouvrez une fenêtre de terminal et exécutez la commande suivante pour installer Homebrew :
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Ajout du dépôt HashiCorp** :

   Exécutez la commande suivante pour ajouter le dépôt HashiCorp à Homebrew :
   ```bash
   brew tap hashicorp/tap
   ```

3. **Installation de Terraform** :

   Installez Terraform en utilisant Homebrew :
   ```bash
   brew install hashicorp/tap/terraform
   ```

4. **Vérification de l'installation** :

   Vérifiez que Terraform est correctement installé en exécutant la commande suivante dans le terminal :
   ```bash
   terraform --version
   ```
   Cette commande doit afficher la version de Terraform installée.

## Installation manuelle

Si vous ne souhaitez pas utiliser Homebrew, vous pouvez installer Terraform manuellement en suivant ces étapes :

1. **Téléchargement de Terraform** :

   Téléchargez le binaire Terraform pour macOS depuis la page de téléchargement officielle :
   [Terraform Downloads](https://www.terraform.io/downloads.html).

2. **Extraction de l'archive ZIP** :

   Une fois le fichier ZIP téléchargé, utilisez l'Utilitaire d'archive (Archive Utility) pour décompresser l'archive. Le binaire `terraform` sera extrait.

3. **Déplacement de l'exécutable** :

   Déplacez le binaire Terraform extrait vers un répertoire inclus dans votre PATH, par exemple `/usr/local/bin/` :
   ```bash
   sudo mv terraform /usr/local/bin/
   ```

4. **Vérification de l'installation** :

   Vérifiez que Terraform est correctement installé en exécutant la commande suivante dans le terminal :
   ```bash
   terraform --version
   ```
   Cette commande doit afficher la version de Terraform installée.

## Mise à jour de Terraform

Pour mettre à jour Terraform avec Homebrew, vous pouvez simplement exécuter la commande suivante :
```bash
brew upgrade hashicorp/tap/terraform
```

Pour une installation manuelle, téléchargez la nouvelle version du binaire depuis le site officiel et remplacez l'ancien fichier par le nouveau dans votre répertoire d'installation.

### Conclusion

Vous avez maintenant installé Terraform sur votre système macOS et êtes prêt à commencer à écrire et exécuter vos premières configurations d'infrastructure. Consultez la documentation officielle pour découvrir les nombreuses fonctionnalités offertes par Terraform.
