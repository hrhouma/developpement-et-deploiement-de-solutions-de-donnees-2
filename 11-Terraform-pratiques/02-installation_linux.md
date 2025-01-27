---
title: "Pratique 02 - Installation de Terraform sur Linux"
description: "Découvrez comment installer Terraform sur Linux."
emoji: "🚀"
slug: "02-installation_linux"
sidebar_position: 2
---

# Installation de Terraform sur Linux

Terraform peut être installé sur diverses distributions Linux. Voici comment l'installer sur les distributions les plus courantes.

## Installation sur Ubuntu/Debian

1. **Téléchargement de Terraform**

   Téléchargez le binaire Terraform pour Linux depuis le site officiel :
   ```bash
   wget https://releases.hashicorp.com/terraform/1.x.x/terraform_1.x.x_linux_amd64.zip
   ```
   Remplacez `1.x.x` par la version spécifique que vous souhaitez installer.

2. **Extraction de l'archive ZIP**

   Décompressez l'archive téléchargée :
   ```bash
   unzip terraform_1.x.x_linux_amd64.zip
   ```

3. **Déplacement de l'exécutable**

   Déplacez l'exécutable Terraform vers un répertoire inclus dans votre PATH, par exemple `/usr/local/bin/` :
   ```bash
   sudo mv terraform /usr/local/bin/
   ```

4. **Vérification de l'installation**

   Vérifiez que Terraform est correctement installé en exécutant la commande suivante :
   ```bash
   terraform --version
   ```
   Cette commande doit afficher la version de Terraform installée.

## Installation sur CentOS/RHEL

1. **Téléchargement de Terraform**

   Téléchargez le binaire Terraform pour Linux depuis le site officiel :
   ```bash
   wget https://releases.hashicorp.com/terraform/1.x.x/terraform_1.x.x_linux_amd64.zip
   ```
   Remplacez `1.x.x` par la version spécifique que vous souhaitez installer.

2. **Extraction de l'archive ZIP**

   Décompressez l'archive téléchargée :
   ```bash
   unzip terraform_1.x.x_linux_amd64.zip
   ```

3. **Déplacement de l'exécutable**

   Déplacez l'exécutable Terraform vers un répertoire inclus dans votre PATH, par exemple `/usr/local/bin/` :
   ```bash
   sudo mv terraform /usr/local/bin/
   ```

4. **Vérification de l'installation**

   Vérifiez que Terraform est correctement installé en exécutant la commande suivante :
   ```bash
   terraform --version
   ```
   Cette commande doit afficher la version de Terraform installée.

## Installation via un Gestionnaire de Paquets

Sur certaines distributions, vous pouvez installer Terraform via un gestionnaire de paquets comme APT ou YUM. Cependant, cela pourrait ne pas toujours fournir la version la plus récente.

### Ubuntu/Debian

```bash
sudo apt-get update && sudo apt-get install -y terraform
```

### CentOS/RHEL

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
```

## Mise à jour de Terraform

Pour mettre à jour Terraform, téléchargez simplement la nouvelle version du binaire à partir du site officiel et remplacez l'ancien exécutable dans le répertoire où il a été installé.

### Conclusion

Terraform est maintenant installé sur votre système Linux, et vous êtes prêt à commencer à gérer vos infrastructures avec cet outil puissant. Consultez la documentation officielle pour plus de détails sur les fonctionnalités avancées de Terraform.
