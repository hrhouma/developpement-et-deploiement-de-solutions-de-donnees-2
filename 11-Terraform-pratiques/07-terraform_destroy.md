---
title: "Pratique 07 - Terraform Destroy"
description: "Découvrez la commande `terraform destroy` et son rôle dans le workflow Terraform."
emoji: "🚀"
slug: "07-terraform_destroy"
sidebar_position: 7
---

# terraform destroy

La commande `terraform destroy` est utilisée pour détruire les ressources gérées par Terraform. C'est l'inverse de `terraform apply` et elle supprime toutes les ressources définies dans les fichiers de configuration.

## Fonctionnalités de `terraform destroy`

- **Suppression des ressources** : `terraform destroy` supprime toutes les ressources définies par Terraform.
- **Confirmation des actions** : Comme `terraform apply`, la commande demande une confirmation avant de procéder à la destruction.
- **Mise à jour de l'état** : Après destruction, Terraform met à jour le fichier d'état pour refléter que les ressources ont été supprimées.

## Exemple d'utilisation

```bash
terraform destroy
```

Cela supprimera toutes les ressources gérées par Terraform après confirmation.

## Options principales de terraform destroy
*Les options principales qui sont disponibles avec la commande `terraform destroy` sont listées ci-dessous :*

- `--help` : Affiche l'aide pour la commande `terraform destroy` et liste toutes les options disponibles ➜ `terraform destroy --help`
- `-auto-approve` : Ignore la confirmation interactive avant la destruction ➜ `terraform destroy -auto-approve`
- `-backup=path` : Chemin du fichier de sauvegarde de l'état avant destruction ➜ `terraform destroy -backup=path`
- `-lock=true` : Verrouille l'état pendant les opérations (activé par défaut) ➜ `terraform destroy -lock=true`
- `-lock-timeout=0s` : Durée d'attente pour le verrouillage de l'état ➜ `terraform destroy -lock-timeout=0s`
- `-no-color` : Désactive les codes de couleur dans la sortie ➜ `terraform destroy -no-color`
- `-parallelism=n` : Limite le nombre d'opérations parallèles ➜ `terraform destroy -parallelism=10`
- `-refresh=true` : Met à jour l'état avant la destruction (activé par défaut) ➜ `terraform destroy -refresh=true`
- `-state=path` : Chemin vers un fichier d'état alternatif ➜ `terraform destroy -state=path`
- `-target=resource` : Cible une ressource spécifique à détruire ➜ `terraform destroy -target=aws_instance.example`
- `-var 'foo=bar'` : Définit une variable de configuration ➜ `terraform destroy -var 'instance_type=t2.micro'`
- `-var-file=foo` : Définit les variables à partir d'un fichier ➜ `terraform destroy -var-file=prod.tfvars`

### Exemple avec options

```bash
terraform destroy --auto-approve --backup=path --lock=true --lock-timeout=0s --no-color --parallelism=10 --refresh=true --state=path --target=resource --var 'foo=bar' --var-file=foo
```

### Conclusion

`terraform destroy` est une commande puissante qui doit être utilisée avec précaution. Elle permet de supprimer toute l'infrastructure gérée par Terraform, libérant ainsi les ressources utilisées.
