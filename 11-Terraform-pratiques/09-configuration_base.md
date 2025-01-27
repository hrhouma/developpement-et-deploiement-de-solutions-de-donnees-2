---
title: "Pratique 09 - Configuration de Base de Terraform"
description: "Découvrez les éléments de base pour configurer Terraform."
emoji: "🚀"
slug: "09-configuration_base"
sidebar_position: 9
---

# Configuration de Base de Terraform

Pour configurer Terraform, voici les étapes essentielles à suivre :

1. [Créer un répertoire de travail pour votre projet](#1-initialisation-du-répertoire-de-travail)
2. [Créer le fichier principal de configuration `main.tf`](#2-fichier-principal-de-configuration)
3. [Initialiser le projet](#3-initialisation-du-projet)
4. [Planifier les changements](#4-planification-des-changements)
5. [Appliquer les modifications](#5-application-des-changements)
6. [Gestion de l'état](#6-gestion-de-létat)
7. [Détruire l'infrastructure](#7-détruire-linfrastructure)
8. [Conclusion](#8-conclusion)



<a name="1-initialisation-du-répertoire-de-travail"></a>
## 1. Initialisation du Répertoire de Travail

Pour commencer, créez un nouveau répertoire pour votre projet Terraform. Ce répertoire contiendra tous vos fichiers de configuration.

```bash
mkdir mon-projet-terraform
cd mon-projet-terraform
```

<a name="2-fichier-principal-de-configuration"></a>
## 2. Fichier principal de Configuration : `main.tf`

Le fichier principal de configuration de Terraform est généralement nommé `main.tf`. Il peut contenir des blocs de configuration pour les providers, les ressources, les modules, et d'autres éléments.

Voici un exemple de fichier `main.tf` minimal pour démarrer :

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

Dans cet exemple :

- Le bloc `provider` spécifie que vous utilisez AWS comme fournisseur, et que la région est `us-west-2`.
- Le bloc `resource` définit une instance EC2 avec un type de machine `t2.micro`.

<a name="3-initialisation-du-projet"></a>
## 3. Initialisation du Projet

Avant de pouvoir exécuter des commandes Terraform, vous devez initialiser le répertoire de travail. Cette étape télécharge les plugins nécessaires pour les providers spécifiés.

```bash
terraform init
```

<a name="4-planification-des-changements"></a>
## 4. Planification des Changements

La commande `terraform plan` vous permet de voir les changements qui seront apportés à l'infrastructure avant de les appliquer. Cela génère un plan d'exécution que vous pouvez examiner.

```bash
terraform plan
```

<a name="5-application-des-changements"></a>
## 5. Application des Changements

Après avoir examiné le plan, vous pouvez appliquer les changements pour créer, modifier ou détruire les ressources définies dans vos fichiers de configuration.

```bash
terraform apply
```

Terraform vous demandera de confirmer l'application des changements. Vous pouvez également utiliser l'option `-auto-approve` pour appliquer les changements sans confirmation.

<a name="6-gestion-de-létat"></a>
## 6. Gestion de l'État


Terraform maintient un fichier d'état (`terraform.tfstate`) dans le répertoire de travail. Ce fichier garde une trace des ressources gérées par Terraform et de leurs configurations actuelles. Il est essentiel pour que Terraform puisse déterminer les actions nécessaires lors des futurs déploiements.


<a name="7-détruire-linfrastructure"></a>
## 7. Détruire l'Infrastructure

Si vous souhaitez supprimer toutes les ressources gérées par Terraform, vous pouvez utiliser la commande `terraform destroy`.

```bash
terraform destroy
```

Cette commande supprimera toutes les ressources définies dans vos fichiers de configuration et mises en place par Terraform.

<a name="8-conclusion"></a>
## 8. Conclusion

Ces étapes constituent la base de l'utilisation de Terraform pour gérer l'infrastructure. Une fois que vous êtes à l'aise avec ces concepts de base, vous pouvez explorer des fonctionnalités plus avancées, telles que l'utilisation de modules, la gestion de plusieurs environnements, et l'intégration avec des pipelines CI/CD.
