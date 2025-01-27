---
title: "Pratique 10 - Les commandes Terraform les plus utilisées"
description: "Découvrez les commandes Terraform essentielles pour gérer votre infrastructure."
emoji: "⚡"
slug: "10-commandes-les-plus-utilisees"
sidebar_position: 10
---

# Les commandes Terraform les plus utilisées

Voici un guide des commandes Terraform les plus couramment utilisées pour gérer votre infrastructure as code.

## 01 - Commandes essentielles pour la gestion de l'infrastructure

Cette section présente les commandes fondamentales de Terraform que vous utiliserez quotidiennement pour gérer votre infrastructure as code. Ces commandes constituent la base de tout workflow Terraform et sont indispensables pour une utilisation efficace de l'outil.

- `terraform init` : Initialise un répertoire de travail Terraform en téléchargeant les plugins nécessaires et en préparant l'environnement
- `terraform plan` : Crée un plan d'exécution
- `terraform apply` : Applique les changements à l'infrastructure
- `terraform destroy` : Détruit l'infrastructure gérée

## 02 - Commandes importantes pour la gestion du code

Cette section présente les commandes Terraform essentielles pour maintenir la qualité et la lisibilité de votre code d'infrastructure. Ces commandes vous aident à valider, formater et organiser votre code Terraform de manière efficace.

- `terraform validate` : Valide les fichiers de configuration
- `terraform fmt` : Formate les fichiers de configuration
- `terraform version` : Affiche la version de Terraform
- `terraform workspace list` : Liste les workspaces
- `terraform workspace new` : Crée un nouveau workspace
- `terraform workspace select` : Sélectionne un workspace

## 03 - Commandes essentielles à maîtriser


:::danger À ne jamais oublier
- `terraform init` 
- `terraform apply --auto-approve` 
- `terraform destroy --auto-approve` 
:::

Il est crucial de toujours vérifier les changements avant d'appliquer des commandes Terraform, particulièrement celles qui modifient l'infrastructure. Les commandes comme `terraform apply` et `terraform destroy` peuvent avoir des impacts importants et irréversibles sur votre environnement.



# 04 - Tableaux des commandes récapitulatives


### ➜ *Tableau des commandes de base et leurs fonctionnalités*

:::info 
Les commandes essentielles de Terraform sont `init` pour initialiser le projet, `plan` pour prévisualiser les changements, `apply` pour appliquer les modifications et `destroy` pour supprimer l'infrastructure.
:::


| Commande | Description | Exemple |
|----------|-------------|---------|
| `terraform init` | Initialise un répertoire de travail Terraform | `terraform init` |
| `terraform plan` | Crée un plan d'exécution | `terraform plan` |
| `terraform apply` | Applique les changements à l'infrastructure | `terraform apply --auto-approve` |
| `terraform destroy` | Détruit l'infrastructure gérée | `terraform destroy --auto-approve` |



### ➜ *Tableau des options communes et leurs fonctionnalités*
:::info 
Les options communes aux commandes Terraform incluent `--auto-approve` pour ignorer les confirmations, `--target` pour cibler des ressources spécifiques, et `--var-file` pour spécifier des fichiers de variables.
:::

| Option | Description | Exemple |
|--------|-------------|---------|
| `--auto-approve` | Ignore les confirmations interactives | `terraform apply --auto-approve` |
| `--target` | Cible une ressource spécifique | `terraform apply --target aws_instance.example` |
| `--var-file` | Spécifie un fichier de variables | `terraform apply --var-file="prod.tfvars"` |


### ➜ *Tableau des commandes de gestion d'état et leurs fonctionnalités*
:::info 
Les commandes de gestion d'état permettent de manipuler et visualiser l'état de l'infrastructure Terraform, notamment avec `terraform show` pour afficher l'état actuel, `terraform state list` pour lister les ressources et `terraform refresh` pour mettre à jour l'état local.
:::

| Commande | Description | Exemple |
|----------|-------------|---------|
| `terraform show` | Affiche l'état actuel | `terraform show` |
| `terraform state list` | Liste les ressources dans l'état | `terraform state list` |
| `terraform refresh` | Met à jour l'état local | `terraform refresh` |


### ➜ *Tableau des commandes de workspace et leurs fonctionnalités*
:::info 
Les commandes de workspace permettent de gérer les différents environnements de votre infrastructure Terraform, notamment avec `terraform workspace list` pour lister les workspaces, `terraform workspace new` pour créer un nouveau workspace et `terraform workspace select` pour sélectionner un workspace.
:::

| Commande | Description | Exemple |
|----------|-------------|---------|
| `terraform workspace list` | Liste les workspaces | `terraform workspace list` |
| `terraform workspace new` | Crée un nouveau workspace | `terraform workspace new dev` |
| `terraform workspace select` | Sélectionne un workspace | `terraform workspace select prod` |


### ➜ *Tableau des commandes de debug et leurs fonctionnalités*
:::info 
Les commandes de debug permettent de valider, formater et afficher la version de Terraform, notamment avec `terraform validate` pour valider les fichiers de configuration, `terraform fmt` pour formater les fichiers de configuration et `terraform version` pour afficher la version de Terraform.
:::

| Commande | Description | Exemple |
|----------|-------------|---------|
| `terraform validate` | Valide les fichiers de configuration | `terraform validate` |
| `terraform fmt` | Formate les fichiers de configuration | `terraform fmt` |
| `terraform version` | Affiche la version de Terraform | `terraform version` |


### ➜ *Tableau des commandes de gestion d'état et leurs fonctionnalités*
:::info 
Les commandes de gestion d'état permettent de manipuler et visualiser l'état de l'infrastructure Terraform, notamment avec `terraform state mv` pour déplacer des ressources dans l'état, `terraform state rm` pour supprimer des ressources de l'état et `terraform state pull` pour télécharger l'état distant.
:::

| Commande | Description | Exemple |
|----------|-------------|---------|
| `terraform state mv` | Déplace des ressources dans l'état | `terraform state mv aws_instance.old aws_instance.new` |
| `terraform state rm` | Supprime des ressources de l'état | `terraform state rm aws_instance.example` |
| `terraform state pull` | Télécharge l'état distant | `terraform state pull > state.tfstate` |
| `terraform state push` | Envoie l'état local vers le backend distant | `terraform state push state.tfstate` |


## Bonnes pratiques

- Toujours exécuter `terraform plan` avant `terraform apply`
- Versionner les fichiers d'état avec un backend distant
- Formater régulièrement le code avec `terraform fmt`
:::danger et surtout ne pas oublier
- Utiliser `--auto-approve` avec précaution, surtout en production
:::


