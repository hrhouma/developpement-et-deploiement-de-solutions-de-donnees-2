---
title: "Pratique 04 - Terraform Init"
description: "Découvrez la commande `terraform init` et son rôle dans le workflow Terraform."
emoji: "🚀"
slug: "04-terraform_init"
sidebar_position: 4
---

# terraform init

La commande `terraform init` est la première commande à exécuter dans un répertoire de configuration Terraform. Elle initialise le répertoire en téléchargeant les plugins nécessaires pour interagir avec les fournisseurs de cloud et les autres services.

## Fonctionnalités de `terraform init`

- **Téléchargement des plugins** : `terraform init` télécharge les plugins pour chaque fournisseur défini dans les fichiers de configuration.
- **Initialisation du backend** : Si vous utilisez un backend pour stocker l'état de Terraform à distance, `terraform init` configure ce backend.
- **Vérification de la configuration** : La commande vérifie que la configuration est correcte et que toutes les dépendances sont disponibles.

## Exemple d'utilisation

Dans un répertoire contenant un fichier `main.tf` :

```bash
terraform init
```

Cela télécharge les plugins nécessaires et initialise le répertoire pour les prochaines étapes du workflow Terraform.

## Options principales de terraform init

*Les options principales qui sont disponibles avec la commande `terraform init` sont listées ci-dessous :*

- `--help` : Affiche l'aide pour la commande `terraform init` et liste toutes les options disponibles ➜ `terraform init --help`
- `--migrate-state` : Migre l'état Terraform vers un nouveau backend ➜ `terraform init --migrate-state`
- `--upgrade=true` : Met à jour les plugins vers la dernière version compatible ➜ `terraform init --upgrade=true`
- `-backend=true` : Configure le backend pour stocker l'état Terraform (activé par défaut) ➜ `terraform init -backend=true`
- `--backend-config=path` : Fichier de configuration supplémentaire pour le backend ➜ `terraform init --backend-config=path`
- `--force-copy` : Force la copie des fichiers d'état plutôt que de créer des liens symboliques ➜ `terraform init --force-copy`
- `--from-module=SOURCE` : Copie le contenu du module source dans le répertoire de travail ➜ `terraform init --from-module=SOURCE`
- `--get=true` : Télécharge/met à jour les modules (activé par défaut) ➜ `terraform init --get=true`
- `--input=true` : Demande une saisie utilisateur pour les variables si nécessaire ➜ `terraform init --input=true`
- `--lock=true` : Verrouille l'état pendant les opérations (activé par défaut) ➜ `terraform init --lock=true`
- `--lock-timeout=0s` : Durée d'attente pour le verrouillage de l'état ➜ `terraform init --lock-timeout=0s`
- `-no-color` : Désactive les codes de couleur dans la sortie ➜ `terraform init -no-color`
- `--plugin-dir` : Répertoire contenant les plugins à utiliser ➜ `terraform init --plugin-dir=plugins`
- `--reconfigure` : Reconfigure le backend, ignorant tout état existant ➜ `terraform init --reconfigure`
- `--upgrade` : Met à jour les plugins à la dernière version compatible ➜ `terraform init --upgrade`
- `--verify-plugins=true` : Vérifie les signatures des plugins (activé par défaut) ➜ `terraform init --verify-plugins=true`

### Exemple avec options

```bash
terraform init -backend=false -get=false -input=false -lock=false -lock-timeout=0s -no-color -plugin-dir=plugins -reconfigure -upgrade -verify-plugins=false
```

### Conclusion

`terraform init` est une commande essentielle pour démarrer tout projet Terraform. Elle prépare l'environnement pour le reste du cycle de vie de l'infrastructure.

