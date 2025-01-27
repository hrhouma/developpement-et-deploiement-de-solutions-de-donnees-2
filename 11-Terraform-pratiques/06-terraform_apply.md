---
title: "Pratique 06 - Terraform Apply"
description: "Découvrez la commande `terraform apply` et son rôle dans le workflow Terraform."
emoji: "🚀"
slug: "06-terraform_apply"
sidebar_position: 6
---

# terraform apply

La commande `terraform apply` applique les changements spécifiés dans les fichiers de configuration Terraform à l'infrastructure. Elle exécute les actions nécessaires pour créer, modifier ou supprimer les ressources.

## Fonctionnalités de `terraform apply`

- **Application des changements** : `terraform apply` lit le plan d'exécution généré par `terraform plan` et applique les changements à l'infrastructure.
- **Confirmation des actions** : Par défaut, la commande demande une confirmation avant d'appliquer les changements. Vous pouvez contourner cette confirmation avec l'option `-auto-approve`.
- **Gestion de l'état** : Après l'application, Terraform met à jour le fichier d'état pour refléter les changements.

## Exemple d'utilisation

```bash
terraform apply
```

Cela appliquera les changements après confirmation.

## Options principales de terraform apply
*Les options principales qui sont disponibles avec la commande `terraform apply` sont listées ci-dessous :*

- `--help` : Affiche l'aide pour la commande `terraform apply` et liste toutes les options disponibles ➜ `terraform apply --help`
- `-auto-approve` : Ignore la confirmation interactive avant d'appliquer les changements ➜ `terraform apply -auto-approve`
- `-backup=path` : Chemin du fichier de sauvegarde de l'état ➜ `terraform apply -backup=path`
- `-compact-warnings` : Affiche les avertissements de manière plus compacte ➜ `terraform apply -compact-warnings`
- `-lock=true` : Verrouille l'état pendant les opérations (activé par défaut) ➜ `terraform apply -lock=true`
- `-lock-timeout=0s` : Durée d'attente pour le verrouillage de l'état ➜ `terraform apply -lock-timeout=0s`
- `-no-color` : Désactive les codes de couleur dans la sortie ➜ `terraform apply -no-color`
- `-parallelism=n` : Limite le nombre d'opérations parallèles ➜ `terraform apply -parallelism=10`
- `-refresh=true` : Met à jour l'état avant de planifier (activé par défaut) ➜ `terraform apply -refresh=true`
- `-state=path` : Chemin du fichier d'état à utiliser ➜ `terraform apply -state=path`
- `-state-out=path` : Chemin où écrire le fichier d'état mis à jour ➜ `terraform apply -state-out=path`
- `-target=resource` : Cible une ressource spécifique à appliquer ➜ `terraform apply -target=aws_instance.example`
- `-var 'name=value'` : Définit une variable de configuration ➜ `terraform apply -var 'instance_type=t2.micro'`
- `-var-file=file` : Fichier contenant des variables de configuration ➜ `terraform apply -var-file=prod.tfvars`

### Exemple avec options

```bash
terraform apply --auto-approve --backup=path --compact-warnings --lock=true --lock-timeout=0s --no-color --parallelism=10 --refresh=true --state=path --state-out=path --target=resource --var 'name=value' --var-file=file
```


### Conclusion

`terraform apply` est la commande qui exécute les modifications sur l'infrastructure. Elle est cruciale pour mettre en œuvre les changements planifiés dans l'infrastructure gérée par Terraform.
